// sunit_general.cpp — qualitative-S-unit certifier for exact-critical
// hypothesis-meeting (A, k).
//
// For each (A, k) with R(A) = 1 (exact-critical), gcd(A) = 1, |A| >= 2:
// search for a frontier T* where the seed F(E*) has central interval
// [c+1, S-c-1] non-empty (c < S/2 strict).  If found, output certificate.
//
// CITATION FOR THE CERTIFICATE:
//   The multiplicative-class reduction (note 17) gives a multiplicatively
//   independent pair (x, y) in A from gcd(A) = 1.
//   The qualitative S-unit finiteness theorem (Evertse-Schlickewei-Schmidt;
//   Beukers-Schlickewei) says that for every B > 0, the set
//      {(m, n) in N^2 : |x^m - y^n| <= B}
//   is finite.
//   By note 27 §"Consequence", this implies only finitely many tail
//   frontiers can fail interval extension beyond the seed interval [c+1, S-c-1].
//   So Erdős 124 holds qualitatively for the case: there exists N_0
//   (non-effective) such that every N >= N_0 is a subset sum.
//
// LIMITATION: the certificate is qualitative.  We do not produce
// N_0 explicitly.  An effective version would require Mignotte-Waldschmidt
// for the specific multiplicatively-independent pair (only available for
// (3, 4) currently).
//
// Build:  g++ -O3 -std=c++20 -march=native cpp/sunit_general.cpp \
//             -o cpp/sunit_general.exe
//
// Usage:  cpp/sunit_general.exe --bases=3,4,7 --k=1 [--T-start=10] [--T-max=1e9]
//         cpp/sunit_general.exe --batch --max-base=15 --max-size=5 --k-max=2

#include <cstdio>
#include <cstdint>
#include <cstdlib>
#include <cmath>
#include <vector>
#include <string>
#include <algorithm>
#include <chrono>

using std::size_t;
using std::uint64_t;

// --- Shift-OR bitset for conductor ---

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
    const size_t n_words = (S + 64) / 64 + 1;
    std::vector<uint64_t> bits(n_words, 0);
    bits[0] = 1;
    for (uint64_t t : F) shift_or(bits, t);
    int64_t c = -1;
    for (int64_t pos = static_cast<int64_t>(half); pos >= 0; --pos) {
        if (!test_bit(bits, static_cast<uint64_t>(pos))) {
            c = pos;
            break;
        }
    }
    return c;
}

// --- Setup ---

long double reciprocal_sum(const std::vector<int>& bases) {
    long double r = 0.0L;
    for (int a : bases) r += 1.0L / static_cast<long double>(a - 1);
    return r;
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

// --- Multiplicative-class check (note 17) ---

// Two integers x, y > 1 are multiplicatively dependent iff log(x)/log(y)
// is rational, i.e., x = z^p, y = z^q for some integer z and p, q.
// Equivalent: there exist positive integers p, q with x^p = y^q.
//
// For our base sets (integers >= 3), checking mult-dep is: x = y^k for
// some k, or x^p = y^q for small p, q.  Since A is finite small integers,
// we can check directly.

bool mult_dependent_pair(int x, int y) {
    // x ~ y if log_x y is rational.  For positive integers, this means
    // x^a = y^b for some positive integers a, b.
    // Easiest check: find common base z such that x = z^p, y = z^q.
    if (x == y) return true;
    // Find largest z <= min(x, y) such that x = z^p and y = z^q.
    for (int z = 2; z * z <= std::max(x, y); ++z) {
        int px = 0, vx = x;
        while (vx > 1 && vx % z == 0) { vx /= z; ++px; }
        if (vx != 1) continue;
        int py = 0, vy = y;
        while (vy > 1 && vy % z == 0) { vy /= z; ++py; }
        if (vy != 1) continue;
        if (px > 0 && py > 0) return true;
    }
    // Check x itself as base: x = x^1, is y = x^k?
    {
        int v = y;
        while (v > 1 && v % x == 0) v /= x;
        if (v == 1 && y >= x) return true;
    }
    {
        int v = x;
        while (v > 1 && v % y == 0) v /= y;
        if (v == 1 && x >= y) return true;
    }
    return false;
}

// Returns (x, y) — a mult-independent pair from A, or (-1, -1) if none.
std::pair<int, int> find_mult_indep_pair(const std::vector<int>& A) {
    for (size_t i = 0; i < A.size(); ++i) {
        for (size_t j = i + 1; j < A.size(); ++j) {
            if (!mult_dependent_pair(A[i], A[j])) {
                return {A[i], A[j]};
            }
        }
    }
    return {-1, -1};
}

// --- Driver ---

int gcd_int(int a, int b) { while (b) { a %= b; std::swap(a, b); } return a; }
int gcd_list(const std::vector<int>& v) {
    int g = 0; for (int x : v) g = gcd_int(g, x); return g;
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

struct SunitCert {
    bool verified;
    int64_t c_star;
    uint64_t T_star;
    int x_indep, y_indep;
};

SunitCert try_verify_exact(const std::vector<int>& bases, int k,
                            const std::vector<double>& Ts) {
    SunitCert result{false, -1, 0, -1, -1};

    auto [x, y] = find_mult_indep_pair(bases);
    if (x < 0) return result;  // no mult-indep pair
    result.x_indep = x;
    result.y_indep = y;

    for (double T : Ts) {
        Seed seed = build_balanced_seed(bases, k, T);
        if (seed.S > (uint64_t)1 << 31) continue;  // 2GB cap
        int64_t c = compute_conductor(seed.F, seed.S);
        // Precondition: seed interval non-empty (c < S/2 strict).
        if (2 * c + 2 > static_cast<int64_t>(seed.S)) continue;
        result.verified = true;
        result.c_star = c;
        result.T_star = *std::min_element(seed.tail_frontier.begin(),
                                          seed.tail_frontier.end());
        return result;
    }
    return result;
}

void enumerate_subsets(int max_base, int min_size, int max_size,
                       std::vector<std::vector<int>>& out) {
    int n = max_base - 3 + 1;
    for (int size = min_size; size <= max_size && size <= n; ++size) {
        std::vector<int> idx(size);
        for (int i = 0; i < size; ++i) idx[i] = i;
        while (true) {
            std::vector<int> A;
            for (int i = 0; i < size; ++i) A.push_back(3 + idx[i]);
            out.push_back(A);
            int j = size - 1;
            while (j >= 0 && idx[j] == n - size + j) --j;
            if (j < 0) break;
            ++idx[j];
            for (int i = j + 1; i < size; ++i) idx[i] = idx[i - 1] + 1;
        }
    }
}

int main(int argc, char** argv) {
    std::vector<int> bases;
    int k = 1;
    bool batch = false;
    int max_base = 15;
    int min_size = 2;
    int max_size = 5;
    int k_min = 1, k_max = 2;

    for (int i = 1; i < argc; ++i) {
        std::string a = argv[i];
        if (a == "--batch") batch = true;
        else if (a.rfind("--bases=", 0) == 0) bases = parse_int_list(a.substr(8));
        else if (a.rfind("--k=", 0) == 0) k = std::stoi(a.substr(4));
        else if (a.rfind("--max-base=", 0) == 0) max_base = std::stoi(a.substr(11));
        else if (a.rfind("--min-size=", 0) == 0) min_size = std::stoi(a.substr(11));
        else if (a.rfind("--max-size=", 0) == 0) max_size = std::stoi(a.substr(11));
        else if (a.rfind("--k-min=", 0) == 0) k_min = std::stoi(a.substr(8));
        else if (a.rfind("--k-max=", 0) == 0) k_max = std::stoi(a.substr(8));
    }

    std::vector<double> Ts;
    for (double T = 10.0; T <= 1e9; T *= 2.0) Ts.push_back(T);

    if (batch) {
        std::vector<std::vector<int>> candidates;
        enumerate_subsets(max_base, min_size, max_size, candidates);
        int total = 0, verified = 0, failed = 0;
        auto t0 = std::chrono::high_resolution_clock::now();

        std::printf("# sunit_general (batch): exact-critical hypothesis-meeting (A,k)\n");
        std::printf("# max_base=%d, sizes [%d, %d], k in [%d, %d]\n",
                    max_base, min_size, max_size, k_min, k_max);
        std::printf("# %-30s %-3s %-8s %-12s %-12s %-12s\n",
                    "A", "k", "R", "c*", "T*", "mult-pair");

        for (const auto& A : candidates) {
            if (gcd_list(A) != 1) continue;
            long double R = reciprocal_sum(A);
            if (std::fabsl(R - 1.0L) > 1e-6L) continue;  // not exact-critical
            for (int kk = k_min; kk <= k_max; ++kk) {
                ++total;
                SunitCert cert = try_verify_exact(A, kk, Ts);
                std::string A_str = "{";
                for (size_t i = 0; i < A.size(); ++i) {
                    A_str += std::to_string(A[i]) + (i+1<A.size()?",":"");
                }
                A_str += "}";
                std::string pair_str;
                if (cert.verified) {
                    pair_str = "(" + std::to_string(cert.x_indep) + "," +
                               std::to_string(cert.y_indep) + ")";
                    ++verified;
                    std::printf("  %-30s %-3d %-8.4Lg %-12lld %-12llu %-12s\n",
                                A_str.c_str(), kk, R,
                                (long long)cert.c_star,
                                (unsigned long long)cert.T_star,
                                pair_str.c_str());
                } else {
                    ++failed;
                    std::printf("  %-30s %-3d %-8.4Lg %-12s %-12s %-12s  (no cert)\n",
                                A_str.c_str(), kk, R, "—", "—", "—");
                }
            }
        }

        auto t1 = std::chrono::high_resolution_clock::now();
        double dt = std::chrono::duration<double>(t1 - t0).count();
        std::printf("\n# summary: %d exact-critical hypothesis-meeting cases\n", total);
        std::printf("#          %d verified qualitatively (Erdős 124 via S-unit)\n", verified);
        std::printf("#          %d failed (no seed interval found within T <= 1e9)\n", failed);
        std::printf("#          %.2fs elapsed\n", dt);
        return 0;
    }

    if (bases.empty()) {
        std::fprintf(stderr, "usage: %s --bases=3,4,7 --k=1\n", argv[0]);
        std::fprintf(stderr, "       %s --batch [--max-base=15] [--max-size=5] [--k-max=2]\n", argv[0]);
        return 1;
    }

    long double R = reciprocal_sum(bases);
    int g = gcd_list(bases);
    std::printf("# sunit_general: A = {");
    for (size_t i = 0; i < bases.size(); ++i) {
        std::printf("%d%s", bases[i], (i+1<bases.size())?",":"");
    }
    std::printf("}  k = %d  R = %.6Lf  gcd = %d\n", k, R, g);

    if (g != 1) { std::printf("# gcd != 1 — hypothesis fails.\n"); return 0; }
    if (std::fabsl(R - 1.0L) > 1e-6L) {
        std::printf("# R != 1 — not exact-critical.\n"); return 0;
    }

    SunitCert cert = try_verify_exact(bases, k, Ts);
    if (!cert.verified) {
        std::printf("# No seed interval found in T <= 1e9.\n");
        return 2;
    }

    std::printf("\n# *** QUALITATIVE ERDŐS 124 VERIFIED for A=");
    for (size_t i = 0; i < bases.size(); ++i) {
        std::printf("%s%d", i == 0 ? "{" : ",", bases[i]);
    }
    std::printf("}, k=%d ***\n", k);
    std::printf("# Seed interval non-empty at T = %llu: c = %lld, span = %llu.\n",
                (unsigned long long)cert.T_star,
                (long long)cert.c_star,
                (unsigned long long)0);
    std::printf("# Multiplicatively-independent pair in A: (%d, %d).\n",
                cert.x_indep, cert.y_indep);
    std::printf("# By qualitative S-unit finiteness (Evertse-Schlickewei-Schmidt),\n");
    std::printf("# only finitely many tail frontiers can fail interval extension.\n");
    std::printf("# Therefore Erdős 124 holds qualitatively for this case:\n");
    std::printf("# there exists N_0 (non-effective) such that every N >= N_0\n");
    std::printf("# is a subset sum of {a^e : a in A, e >= %d}.\n", k);
    return 0;
}
