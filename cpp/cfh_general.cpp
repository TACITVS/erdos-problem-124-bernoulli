// cfh_general.cpp — generalized CFH-strict bounded-conductor verifier.
//
// For a strict hypothesis-meeting (A, k) with R(A) = sum 1/(a-1) > 1,
// search for a balanced frontier E* where:
//   1. The seed conductor c* = c(F(E*)) is finite and < S(E*)/2.
//   2. The CFH condition b_n <= b_1 + ... + b_{n-1} + b_1 holds along
//      the tail beyond E*.
//   3. Strict takeover triggers within `max_steps` advance steps.
//
// If found, output (e*, c*, takeover_step) and a flag that the Bounded
// Conductor Conjecture is *verified* for this (A, k) — every E ⊇ E*
// has c(E) <= c*.
//
// This generalises notes/26 CFH proof for {3,4,5}, k=1, to arbitrary
// strict hypothesis-meeting (A, k).  Same algebraic conditions; only
// the seed conductor and frontier choice depend on (A, k).
//
// Build:  g++ -O3 -std=c++20 -march=native cpp/cfh_general.cpp \
//             -o cpp/cfh_general.exe
//
// Usage:  cpp/cfh_general.exe --bases=3,4,5 --k=1 [--e-start=2] [--e-max=20]

#include <cstdio>
#include <cstdint>
#include <cstdlib>
#include <cmath>
#include <vector>
#include <string>
#include <algorithm>

using std::size_t;
using std::uint64_t;

// --- Shift-OR bitset for conductor computation ---

void shift_or(std::vector<uint64_t>& bits, uint64_t shift) {
    const size_t n = bits.size();
    const uint64_t word_shift = shift / 64;
    const uint64_t bit_shift = shift % 64;
    if (word_shift >= n) return;
    if (bit_shift == 0) {
        for (size_t i = n - 1; i >= word_shift; --i) {
            bits[i] |= bits[i - word_shift];
            if (i == 0) break;
        }
    } else {
        for (size_t i = n - 1; i >= word_shift + 1; --i) {
            uint64_t hi = bits[i - word_shift] << bit_shift;
            uint64_t lo = bits[i - word_shift - 1] >> (64 - bit_shift);
            bits[i] |= hi | lo;
            if (i == word_shift + 1) break;
        }
        bits[word_shift] |= bits[0] << bit_shift;
    }
}

inline bool test_bit(const std::vector<uint64_t>& bits, uint64_t b) {
    return (bits[b / 64] >> (b % 64)) & 1ULL;
}

inline void set_bit(std::vector<uint64_t>& bits, uint64_t b) {
    bits[b / 64] |= 1ULL << (b % 64);
}

// Compute conductor c(F) = largest n in [0, S/2] not representable
// as a subset sum of F.
int64_t compute_conductor(const std::vector<uint64_t>& F, uint64_t S) {
    const uint64_t half = S / 2;
    const size_t n_words = (S + 64) / 64 + 1;
    std::vector<uint64_t> bits(n_words, 0);
    set_bit(bits, 0);
    for (uint64_t t : F) {
        shift_or(bits, t);
    }
    int64_t c = -1;
    for (int64_t pos = static_cast<int64_t>(half); pos >= 0; --pos) {
        if (!test_bit(bits, static_cast<uint64_t>(pos))) {
            c = pos;
            break;
        }
    }
    return c;
}

// --- CFH analysis on the tail ---

// Reciprocal sum R(A) as long double.
long double reciprocal_sum(const std::vector<int>& bases) {
    long double r = 0.0L;
    for (int a : bases) r += 1.0L / static_cast<long double>(a - 1);
    return r;
}

// Tail capital C = sum E_a / (a - 1), as long double.
long double tail_capital(const std::vector<int>& bases,
                          const std::vector<uint64_t>& frontier) {
    long double C = 0.0L;
    for (size_t i = 0; i < bases.size(); ++i) {
        C += static_cast<long double>(frontier[i]) /
             static_cast<long double>(bases[i] - 1);
    }
    return C;
}

uint64_t min_frontier(const std::vector<uint64_t>& frontier) {
    return *std::min_element(frontier.begin(), frontier.end());
}

size_t min_index(const std::vector<uint64_t>& frontier) {
    return std::distance(frontier.begin(),
                         std::min_element(frontier.begin(), frontier.end()));
}

struct CfhResult {
    bool verified;
    int takeover_step;
    int64_t conductor;
    uint64_t T_initial;
    uint64_t T_takeover;
    long double invariant;
};

// Run CFH advance loop.  Strict takeover condition:
//   (R - 1) * T_current >= invariant = C_initial - G
// where G = T_initial = first min frontier.
CfhResult verify_cfh(const std::vector<int>& bases,
                     std::vector<uint64_t> frontier,
                     int max_steps,
                     int64_t seed_conductor) {
    CfhResult result;
    result.verified = false;
    result.takeover_step = -1;
    result.T_takeover = 0;
    result.conductor = seed_conductor;

    const long double R = reciprocal_sum(bases);
    if (R <= 1.0L) {
        return result;  // not strict
    }

    long double C0 = tail_capital(bases, frontier);
    uint64_t G = min_frontier(frontier);
    long double invariant = C0 - static_cast<long double>(G);
    result.T_initial = G;
    result.invariant = invariant;

    long double slack = R - 1.0L;

    for (int step = 0; step <= max_steps; ++step) {
        uint64_t T_now = min_frontier(frontier);
        long double C_now = tail_capital(bases, frontier);
        long double margin = C_now - static_cast<long double>(T_now) - invariant;
        if (margin < 0) {
            // CFH condition fails
            return result;
        }
        if (slack * static_cast<long double>(T_now) >= invariant) {
            result.verified = true;
            result.takeover_step = step;
            result.T_takeover = T_now;
            return result;
        }
        // Advance: multiply the min-frontier element by its base.
        size_t i = min_index(frontier);
        frontier[i] *= static_cast<uint64_t>(bases[i]);
    }
    return result;
}

// --- Driver ---

struct SeedSetup {
    std::vector<uint64_t> F;
    uint64_t S;
    std::vector<uint64_t> tail_frontier;
};

// Build seed F = {a^j : a in A, k <= j < e_a} where each e_a = ceil(log_a T).
// Tail frontier = (a^{e_a})_a — these are the next terms after the seed.
SeedSetup build_setup_balanced(const std::vector<int>& bases, int k, double T) {
    SeedSetup setup;
    setup.S = 0;
    for (int a : bases) {
        int e_a = static_cast<int>(std::ceil(std::log(T) / std::log(static_cast<double>(a))));
        if (e_a < k + 1) e_a = k + 1;  // need at least one seed element
        uint64_t power = 1;
        for (int i = 0; i < e_a; ++i) power *= static_cast<uint64_t>(a);
        while (static_cast<double>(power) < T) {
            ++e_a;
            power *= static_cast<uint64_t>(a);
        }
        // a^{e_a} >= T.  Seed = {a^k, a^{k+1}, ..., a^{e_a-1}}.
        uint64_t t = 1;
        for (int i = 0; i < k; ++i) t *= static_cast<uint64_t>(a);
        for (int j = k; j < e_a; ++j) {
            setup.F.push_back(t);
            setup.S += t;
            t *= static_cast<uint64_t>(a);
        }
        // t is now a^{e_a}.  Tail frontier element.
        setup.tail_frontier.push_back(t);
    }
    return setup;
}

std::vector<int> parse_int_list(const std::string& s) {
    std::vector<int> out;
    size_t pos = 0;
    while (pos < s.size()) {
        size_t next = s.find(',', pos);
        std::string token = s.substr(pos, next - pos);
        if (!token.empty()) out.push_back(std::stoi(token));
        if (next == std::string::npos) break;
        pos = next + 1;
    }
    return out;
}

int main(int argc, char** argv) {
    std::vector<int> bases;
    int k = 1;
    double T_start = 10.0;
    double T_max = 1e9;
    int max_cfh_steps = 100;

    for (int i = 1; i < argc; ++i) {
        std::string a = argv[i];
        if (a.rfind("--bases=", 0) == 0) {
            bases = parse_int_list(a.substr(8));
        } else if (a.rfind("--k=", 0) == 0) {
            k = std::stoi(a.substr(4));
        } else if (a.rfind("--T-start=", 0) == 0) {
            T_start = std::stod(a.substr(10));
        } else if (a.rfind("--T-max=", 0) == 0) {
            T_max = std::stod(a.substr(8));
        } else if (a.rfind("--max-cfh=", 0) == 0) {
            max_cfh_steps = std::stoi(a.substr(10));
        }
    }

    if (bases.empty()) {
        std::fprintf(stderr, "usage: %s --bases=3,4,5 --k=1 [--T-start=10] [--T-max=1e9]\n", argv[0]);
        return 1;
    }

    long double R = reciprocal_sum(bases);
    std::printf("# cfh_general: A = {");
    for (size_t i = 0; i < bases.size(); ++i) {
        std::printf("%d%s", bases[i], (i+1<bases.size())?",":"");
    }
    std::printf("}  k = %d  R = %.4Lf  (%s)\n", k, R,
                R > 1.0L ? "strict" : R == 1.0L ? "exact" : "fails");

    if (R <= 1.0L) {
        std::printf("# CFH-strict route requires R > 1 (strict).  Skipping.\n");
        return 0;
    }

    std::printf("# %-10s %-12s %-12s %-14s %-12s %-8s %-12s\n",
                "T", "T(E*)", "S(E*)", "c(E*)", "invariant", "ready", "verdict");

    // Geometrically increasing T values: 10, 30, 100, 300, ...
    for (double T = T_start; T <= T_max * 1.001; T *= 3.0) {
        SeedSetup setup = build_setup_balanced(bases, k, T);
        if (setup.S > (uint64_t)1 << 33) {
            std::printf("  %-10.2e  (S=%llu too big — stopping)\n", T, (unsigned long long)setup.S);
            break;
        }
        int64_t c_seed = compute_conductor(setup.F, setup.S);
        uint64_t T0 = min_frontier(setup.tail_frontier);
        CfhResult result = verify_cfh(bases, setup.tail_frontier, max_cfh_steps, c_seed);

        // Seed-interval non-emptiness: need 2c + 2 <= S, i.e., the central
        // interval [c+1, S-c-1] to contain at least one element.
        // Also need first tail term to fit: b_1 <= S - 2c - 1 (seed-interval
        // span + 1).
        bool seed_nonempty = (2 * c_seed + 2 <= static_cast<int64_t>(setup.S));
        bool first_absorbs = false;
        if (seed_nonempty) {
            int64_t span_plus_1 = static_cast<int64_t>(setup.S) - 2 * c_seed - 1;
            first_absorbs = (static_cast<int64_t>(T0) <= span_plus_1);
        }
        bool real_verified = result.verified && seed_nonempty && first_absorbs;

        const char* verdict = real_verified ? "BOUNDED" :
            (!seed_nonempty ? "empty-seed" :
             !first_absorbs ? "b1>span+1" :
             !result.verified ? "no-takeover" : "?");

        std::printf("  %-10.2e  %-12llu %-12llu %-14lld %-12.4Lg %-8s %-12s\n",
                    T, (unsigned long long)T0, (unsigned long long)setup.S,
                    (long long)c_seed, result.invariant,
                    real_verified ? "YES" : "no", verdict);

        if (real_verified) {
            std::printf("\n# *** BOUNDED CONDUCTOR VERIFIED for A={");
            for (size_t i = 0; i < bases.size(); ++i) {
                std::printf("%d%s", bases[i], (i+1<bases.size())?",":"");
            }
            std::printf("}, k=%d ***\n", k);
            std::printf("# c*(A, k) <= %lld for all balanced E with T(E) >= %llu.\n",
                        (long long)c_seed, (unsigned long long)T0);
            std::printf("# CFH takeover at step %d with T_takeover = %llu.\n",
                        result.takeover_step, (unsigned long long)result.T_takeover);
            std::printf("# Strict slack (R-1)*T_takeover = %.4Lf >= invariant %.4Lf.\n",
                        (R - 1.0L) * static_cast<long double>(result.T_takeover), result.invariant);
            return 0;
        }
        if (T == T_start && T * 3.0 > T_max) break;  // single-step case
    }

    std::printf("\n# No CFH-verifiable frontier found in T = [%.2e, %.2e].\n", T_start, T_max);
    return 2;
}
