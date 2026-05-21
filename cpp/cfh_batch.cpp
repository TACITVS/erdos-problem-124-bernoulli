// cfh_batch.cpp — enumerate strict hypothesis-meeting (A, k) and certify
// each via CFH-strict (note 67).
//
// For each k in [k_min, k_max] and each finite A ⊆ {3, ..., max_base}
// with gcd(A) = 1 and R(A) > 1, run cfh_general internally and emit
// (A, k, c*, T*).  Skip non-strict (R <= 1) and gcd != 1.
//
// Output: one line per certified case + summary.
//
// Build:  g++ -O3 -std=c++20 -march=native cpp/cfh_batch.cpp \
//             -o cpp/cfh_batch.exe
//
// Usage:  cpp/cfh_batch.exe --max-base=15 --max-size=4 --k-max=2

#include <cstdio>
#include <cstdint>
#include <cstdlib>
#include <cmath>
#include <vector>
#include <string>
#include <algorithm>
#include <numeric>
#include <chrono>

using std::size_t;
using std::uint64_t;

// --- Shift-OR bitset ---

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

int64_t compute_conductor(const std::vector<uint64_t>& F, uint64_t S) {
    const uint64_t half = S / 2;
    // Half-bitset: only need bits for [0, half] since subset sums >= S/2
    // require an element > S/2 (impossible if all elements <= S/2).
    const size_t n_words = (half + 64) / 64 + 1;
    std::vector<uint64_t> bits(n_words, 0);
    bits[0] = 1;
    for (uint64_t t : F) {
        if (t <= half) shift_or(bits, t);
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

// --- CFH analysis ---

long double reciprocal_sum(const std::vector<int>& bases) {
    long double r = 0.0L;
    for (int a : bases) r += 1.0L / static_cast<long double>(a - 1);
    return r;
}

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

struct Seed {
    std::vector<uint64_t> F;
    uint64_t S;
    std::vector<uint64_t> tail_frontier;
};

Seed build_balanced_seed(const std::vector<int>& bases, int k, double T) {
    Seed seed;
    seed.S = 0;
    for (int a : bases) {
        int e_a = static_cast<int>(std::ceil(std::log(T) / std::log(static_cast<double>(a))));
        if (e_a < k + 1) e_a = k + 1;
        uint64_t power = 1;
        for (int i = 0; i < e_a; ++i) power *= static_cast<uint64_t>(a);
        while (static_cast<double>(power) < T) {
            ++e_a;
            power *= static_cast<uint64_t>(a);
        }
        uint64_t t = 1;
        for (int i = 0; i < k; ++i) t *= static_cast<uint64_t>(a);
        for (int j = k; j < e_a; ++j) {
            seed.F.push_back(t);
            seed.S += t;
            t *= static_cast<uint64_t>(a);
        }
        seed.tail_frontier.push_back(t);
    }
    return seed;
}

// Returns (verified, c_star, T_star, takeover_step), or (-, -1, -, -) on failure.
struct CfhCert {
    bool verified;
    int64_t c_star;
    uint64_t T_star;
    int takeover_step;
};

CfhCert try_verify(const std::vector<int>& bases, int k,
                   const std::vector<double>& Ts, int max_cfh) {
    CfhCert result{false, -1, 0, -1};
    long double R = reciprocal_sum(bases);
    long double slack = R - 1.0L;

    for (double T : Ts) {
        Seed seed = build_balanced_seed(bases, k, T);
        if (seed.S > (uint64_t)1 << 37) continue;  // up to ~17GB half-bitset per case
        int64_t c = compute_conductor(seed.F, seed.S);
        uint64_t T0 = min_frontier(seed.tail_frontier);
        // Preconditions (a) and (b)
        bool seed_nonempty = (2 * c + 2 <= static_cast<int64_t>(seed.S));
        if (!seed_nonempty) continue;
        int64_t span_plus_1 = static_cast<int64_t>(seed.S) - 2 * c - 1;
        if (static_cast<int64_t>(T0) > span_plus_1) continue;

        // Precondition (c): CFH advance loop
        std::vector<uint64_t> frontier = seed.tail_frontier;
        long double C0 = tail_capital(bases, frontier);
        long double invariant = C0 - static_cast<long double>(T0);

        bool reached = false;
        int step = 0;
        for (; step <= max_cfh; ++step) {
            uint64_t T_now = min_frontier(frontier);
            long double C_now = tail_capital(bases, frontier);
            long double margin = C_now - static_cast<long double>(T_now) - invariant;
            if (margin < 0) break;
            if (slack * static_cast<long double>(T_now) >= invariant) {
                reached = true;
                break;
            }
            size_t i = min_index(frontier);
            frontier[i] *= static_cast<uint64_t>(bases[i]);
        }
        if (reached) {
            result.verified = true;
            result.c_star = c;
            result.T_star = T0;
            result.takeover_step = step;
            return result;
        }
    }
    return result;
}

// --- Enumeration ---

int gcd_int(int a, int b) {
    while (b) { a %= b; std::swap(a, b); }
    return a;
}

int gcd_list(const std::vector<int>& v) {
    int g = 0;
    for (int x : v) g = gcd_int(g, x);
    return g;
}

void enumerate_subsets(int max_base, int min_size, int max_size,
                        std::vector<std::vector<int>>& out) {
    int n = max_base - 3 + 1;  // bases 3..max_base
    for (int size = min_size; size <= max_size && size <= n; ++size) {
        // generate combinations of {3, ..., max_base} of given size
        std::vector<int> idx(size);
        for (int i = 0; i < size; ++i) idx[i] = i;
        while (true) {
            std::vector<int> A;
            for (int i = 0; i < size; ++i) A.push_back(3 + idx[i]);
            out.push_back(A);
            // advance combination
            int j = size - 1;
            while (j >= 0 && idx[j] == n - size + j) --j;
            if (j < 0) break;
            ++idx[j];
            for (int i = j + 1; i < size; ++i) idx[i] = idx[i - 1] + 1;
        }
    }
}

int main(int argc, char** argv) {
    int max_base = 15;
    int min_size = 3;
    int max_size = 5;
    int k_min = 1;
    int k_max = 1;
    int max_cfh = 200;

    for (int i = 1; i < argc; ++i) {
        std::string a = argv[i];
        if (a.rfind("--max-base=", 0) == 0) max_base = std::stoi(a.substr(11));
        else if (a.rfind("--min-size=", 0) == 0) min_size = std::stoi(a.substr(11));
        else if (a.rfind("--max-size=", 0) == 0) max_size = std::stoi(a.substr(11));
        else if (a.rfind("--k-min=", 0) == 0) k_min = std::stoi(a.substr(8));
        else if (a.rfind("--k-max=", 0) == 0) k_max = std::stoi(a.substr(8));
        else if (a.rfind("--max-cfh=", 0) == 0) max_cfh = std::stoi(a.substr(10));
    }

    std::vector<std::vector<int>> candidates;
    enumerate_subsets(max_base, min_size, max_size, candidates);

    std::vector<double> Ts;
    for (double T = 10.0; T <= 1e11; T *= 2.0) Ts.push_back(T);

    int total_strict = 0, verified = 0, failed = 0;
    auto t0 = std::chrono::high_resolution_clock::now();

    std::printf("# cfh_batch: enumerating strict hypothesis-meeting (A,k) and certifying\n");
    std::printf("# max_base=%d, sizes [%d, %d], k in [%d, %d]\n",
                max_base, min_size, max_size, k_min, k_max);
    std::printf("# %-30s %-3s %-8s %-12s %-12s %-8s\n",
                "A", "k", "R", "c*", "T*", "step");

    for (const auto& A : candidates) {
        if (gcd_list(A) != 1) continue;
        long double R = reciprocal_sum(A);
        // Strict means R > 1 with margin > 1e-9 to avoid floating-point
        // edge cases where exact-critical R = 1 numerically rounds above 1.
        if (R <= 1.0L + 1e-9L) continue;
        for (int k = k_min; k <= k_max; ++k) {
            ++total_strict;
            CfhCert cert = try_verify(A, k, Ts, max_cfh);
            std::string A_str = "{";
            for (size_t i = 0; i < A.size(); ++i) {
                A_str += std::to_string(A[i]) + (i+1<A.size()?",":"");
            }
            A_str += "}";
            if (cert.verified) {
                ++verified;
                std::printf("  %-30s %-3d %-8.4Lg %-12lld %-12llu %-8d\n",
                            A_str.c_str(), k, R,
                            (long long)cert.c_star,
                            (unsigned long long)cert.T_star,
                            cert.takeover_step);
            } else {
                ++failed;
                std::printf("  %-30s %-3d %-8.4Lg %-12s %-12s %-8s  (no cert)\n",
                            A_str.c_str(), k, R, "—", "—", "—");
            }
        }
    }

    auto t1 = std::chrono::high_resolution_clock::now();
    double dt = std::chrono::duration<double>(t1 - t0).count();

    std::printf("\n# summary: %d strict hypothesis-meeting cases tested.\n", total_strict);
    std::printf("#          %d verified (Erdos 124 unconditionally certified)\n", verified);
    std::printf("#          %d failed verification\n", failed);
    std::printf("#          %.2fs elapsed\n", dt);
    return 0;
}
