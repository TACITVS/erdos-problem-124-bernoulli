// l2_collision.cpp — compute L_2(T) = sum_n p_T(n)^2 for various (A, k, T).
//
// L_2 is the collision probability for X_T (probability that two
// independent samples of X_T are equal).  By Erdős-Turán + Cauchy-Schwarz
// (note 76 Theorem E), if L_2(T) = O(1/T), then conductor c(T) = O(T^{1/3}).
//
// Implementation: r(n) = count of subsets summing to n (computed via
// bitscan + counting bits).  Sum of squares is direct.  For large
// 2^|F|, use long-arithmetic counts.
//
// Build:  g++ -O3 -std=c++20 -march=native cpp/l2_collision.cpp \
//             -o cpp/l2_collision.exe

#include <cstdio>
#include <cstdint>
#include <cmath>
#include <vector>
#include <string>
#include <algorithm>

using std::size_t;
using std::uint64_t;

// Compute counts r(n) for n in [0, S] via DP.
// r[n] = number of subsets of F summing to n.
std::vector<uint64_t> count_subset_sums(const std::vector<uint64_t>& F, uint64_t S) {
    std::vector<uint64_t> r(S + 1, 0);
    r[0] = 1;
    for (uint64_t t : F) {
        if (t > S) continue;
        for (int64_t n = S; n >= static_cast<int64_t>(t); --n) {
            r[n] += r[n - t];
        }
    }
    return r;
}

struct Seed {
    std::vector<uint64_t> F;
    uint64_t S;
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
    }
    return seed;
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
        if (a.rfind("--bases=", 0) == 0) bases = parse_int_list(a.substr(8));
        else if (a.rfind("--k=", 0) == 0) k = std::stoi(a.substr(4));
        else if (a.rfind("--T-list=", 0) == 0) Ts = parse_double_list(a.substr(9));
    }

    if (bases.empty() || Ts.empty()) {
        std::fprintf(stderr, "usage: %s --bases=3,4,5 --k=1 --T-list=1e2,1e3,1e4\n", argv[0]);
        return 1;
    }

    std::printf("# l2_collision: A = {");
    for (size_t i = 0; i < bases.size(); ++i) {
        std::printf("%d%s", bases[i], (i+1<bases.size())?",":"");
    }
    std::printf("}  k = %d\n", k);
    std::printf("# %-10s %-12s %-12s %-6s %-16s %-16s %-16s\n",
                "T", "S(E)", "2^|F|", "|F|", "sum r(n)^2", "L_2 = .../4^|F|", "T*L_2 (test)");

    for (double T : Ts) {
        Seed seed = build_balanced_seed(bases, k, T);
        if (seed.S > (uint64_t)1 << 28) {
            std::printf("  %-10.2e  (S=%llu too big for DP)\n",
                        T, (unsigned long long)seed.S);
            continue;
        }
        auto r = count_subset_sums(seed.F, seed.S);
        long double sum_sq = 0;
        for (uint64_t cnt : r) {
            sum_sq += (long double)cnt * (long double)cnt;
        }
        long double pow4 = std::powl(4.0L, (long double)seed.F.size());
        long double L2 = sum_sq / pow4;
        long double T_times_L2 = T * L2;
        long double pow2 = std::powl(2.0L, (long double)seed.F.size());
        std::printf("  %-10.2e  %-12llu  %-12.4Lg  %-6zu  %-16.4Lg  %-16.4Lg  %-16.4Lg\n",
                    T, (unsigned long long)seed.S, pow2,
                    seed.F.size(), sum_sq, L2, T_times_L2);
    }
    return 0;
}
