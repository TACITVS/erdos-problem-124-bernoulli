// conductor_scan.cpp — compute c(E) for balanced frontiers of Erdős 124.
//
// For finite A and exponent floor k, and a balanced frontier E with
// e_a = ceil(log_a T), compute the seed F(E) = {a^j : a in A, k <= j < e_a}
// and the conductor c(E) = largest n in [0, S(E)/2] not representable
// as a subset sum of F(E).
//
// Used to test empirically whether c(E) = o(T(E)) along balanced
// frontiers, which is the "scaled-power-middle-interval" open
// obligation in haskell/ConductorBossTree.hs.
//
// Implementation: dynamic std::vector<uint64_t> as a bitset, with
// shift-and-OR for each seed element.  No OpenMP needed (the inner
// operation is already memory-bandwidth bound).
//
// Build:  g++ -O3 -std=c++20 -march=native cpp/conductor_scan.cpp \
//             -o cpp/conductor_scan.exe
//
// Usage:  cpp/conductor_scan.exe --bases=3,4,7 --k=1 --T=1e6
//         cpp/conductor_scan.exe --bases=3,4,7 --k=1 --T-list=1e3,1e4,1e5,1e6

#include <cstdio>
#include <cstdint>
#include <cstdlib>
#include <cmath>
#include <vector>
#include <string>
#include <chrono>
#include <algorithm>

using std::size_t;
using std::uint64_t;

// Shift bits left by `shift` and OR onto self.  Both operands the same.
// In-place: bits |= bits << shift.  Length stays the same; high bits
// shifted past end are discarded.
void shift_or(std::vector<uint64_t>& bits, uint64_t shift) {
    const size_t n = bits.size();
    const uint64_t word_shift = shift / 64;
    const uint64_t bit_shift = shift % 64;

    if (word_shift >= n) return;

    if (bit_shift == 0) {
        // Whole-word shift.
        for (size_t i = n - 1; i >= word_shift; --i) {
            bits[i] |= bits[i - word_shift];
            if (i == 0) break;
        }
    } else {
        // Mixed-word shift.
        for (size_t i = n - 1; i >= word_shift + 1; --i) {
            uint64_t hi = bits[i - word_shift] << bit_shift;
            uint64_t lo = bits[i - word_shift - 1] >> (64 - bit_shift);
            bits[i] |= hi | lo;
            if (i == word_shift + 1) break;
        }
        // boundary word i == word_shift
        bits[word_shift] |= bits[0] << bit_shift;
    }
}

// Test bit b in bits.
inline bool test_bit(const std::vector<uint64_t>& bits, uint64_t b) {
    return (bits[b / 64] >> (b % 64)) & 1ULL;
}

inline void set_bit(std::vector<uint64_t>& bits, uint64_t b) {
    bits[b / 64] |= 1ULL << (b % 64);
}

// Build the balanced-frontier seed for given bases and k, returning
// (terms, T_min, S, frontier_powers).
struct Seed {
    std::vector<uint64_t> terms;
    uint64_t T_min;
    uint64_t S;
    std::vector<uint64_t> frontier_powers;
};

Seed build_balanced_seed(const std::vector<int>& bases, int k, double T_target) {
    Seed seed;
    seed.T_min = UINT64_MAX;
    seed.S = 0;
    for (int a : bases) {
        int e_a = static_cast<int>(std::ceil(std::log(T_target) / std::log(static_cast<double>(a))));
        // ensure a^e_a >= T_target
        uint64_t power = 1;
        for (int i = 0; i < e_a; ++i) power *= static_cast<uint64_t>(a);
        while (static_cast<double>(power) < T_target) {
            ++e_a;
            power *= static_cast<uint64_t>(a);
        }
        seed.frontier_powers.push_back(power);
        if (power < seed.T_min) seed.T_min = power;
        // Add terms a^j for k <= j < e_a
        uint64_t t = 1;
        for (int i = 0; i < k; ++i) t *= static_cast<uint64_t>(a);
        for (int j = k; j < e_a; ++j) {
            seed.terms.push_back(t);
            seed.S += t;
            t *= static_cast<uint64_t>(a);
        }
    }
    std::sort(seed.terms.begin(), seed.terms.end());
    return seed;
}

// Compute conductor c(E) = largest n in [0, S/2] not representable.
// Uses half-bitset (only stores bits up to S/2) to halve memory for large S.
int64_t compute_conductor(const Seed& seed, uint64_t max_S_bits = (uint64_t)1 << 36) {
    if (seed.S > max_S_bits) {
        return -2;  // too big
    }
    const uint64_t half = seed.S / 2;
    // Bitset of size half+1 (just enough for [0, half]).
    const size_t n_words = (half + 64) / 64 + 1;
    std::vector<uint64_t> bits(n_words, 0);
    set_bit(bits, 0);

    // Note: for the half-bitset shift-OR, bits shifted past `half` are
    // dropped automatically by the bitset size.  This is correct for
    // computing the conductor in [0, half] but loses info about [half, S].
    for (uint64_t t : seed.terms) {
        if (t <= half) shift_or(bits, t);
        // Terms > half contribute via single shifts that overflow the bitset
        // and don't help for conductor in [0, half] (they only add bits
        // above `half`).  Drop them.
    }

    // Find largest position in [0, half] with bit = 0.
    int64_t c = -1;
    for (int64_t pos = static_cast<int64_t>(half); pos >= 0; --pos) {
        if (!test_bit(bits, static_cast<uint64_t>(pos))) {
            c = pos;
            break;
        }
    }
    return c;
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

std::vector<double> parse_double_list(const std::string& s) {
    std::vector<double> out;
    size_t pos = 0;
    while (pos < s.size()) {
        size_t next = s.find(',', pos);
        std::string token = s.substr(pos, next - pos);
        if (!token.empty()) out.push_back(std::stod(token));
        if (next == std::string::npos) break;
        pos = next + 1;
    }
    return out;
}

int main(int argc, char** argv) {
    std::vector<int> bases;
    int k = 1;
    std::vector<double> Ts;

    for (int i = 1; i < argc; ++i) {
        std::string a = argv[i];
        if (a.rfind("--bases=", 0) == 0) {
            bases = parse_int_list(a.substr(8));
        } else if (a.rfind("--k=", 0) == 0) {
            k = std::stoi(a.substr(4));
        } else if (a.rfind("--T=", 0) == 0) {
            Ts.push_back(std::stod(a.substr(4)));
        } else if (a.rfind("--T-list=", 0) == 0) {
            Ts = parse_double_list(a.substr(9));
        }
    }

    if (bases.empty() || Ts.empty()) {
        std::fprintf(stderr, "usage: %s --bases=3,4,7 --k=1 --T=1e6\n", argv[0]);
        std::fprintf(stderr, "       %s --bases=3,4,7 --k=1 --T-list=1e3,1e4,1e5,1e6\n", argv[0]);
        return 1;
    }

    std::printf("# conductor_scan: A = {");
    for (size_t i = 0; i < bases.size(); ++i) {
        std::printf("%d%s", bases[i], (i+1<bases.size())?",":"");
    }
    std::printf("}  k = %d\n", k);
    std::printf("# %-8s %-12s %-14s %-12s %-10s %-10s %-6s %-10s\n",
                "T", "T_min", "S(E)", "c(E)", "c/T", "c/sqrt(T)", "#seed", "time(s)");

    for (double T_target : Ts) {
        Seed seed = build_balanced_seed(bases, k, T_target);
        auto t0 = std::chrono::high_resolution_clock::now();
        int64_t c = compute_conductor(seed);
        auto t1 = std::chrono::high_resolution_clock::now();
        double dt = std::chrono::duration<double>(t1 - t0).count();
        if (c == -2) {
            std::printf("  %-8.0e  %-12llu  %-14llu  (S too big — skipped)\n",
                        T_target,
                        (unsigned long long)seed.T_min,
                        (unsigned long long)seed.S);
            continue;
        }
        double ratio_T = (double)c / (double)seed.T_min;
        double ratio_sqrtT = (double)c / std::sqrt((double)seed.T_min);
        std::printf("  %-8.0e  %-12llu  %-14llu  %-12lld  %-10.4f %-10.2f %-6zu  %-10.3f\n",
                    T_target,
                    (unsigned long long)seed.T_min,
                    (unsigned long long)seed.S,
                    (long long)c,
                    ratio_T,
                    ratio_sqrtT,
                    seed.terms.size(),
                    dt);
    }
    return 0;
}
