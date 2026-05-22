// unified_batch.cpp — single batch driver combining CFH-strict (for
// strict R > 1) and S-unit qualitative (for exact-critical R = 1)
// certification.
//
// For each hypothesis-meeting (A, k) in the enumeration window:
//   - if R > 1 strict: run CFH-strict, report c*, T*
//   - if R = 1 exact: run S-unit qualitative, report c*, T*, indep pair
//   - if R < 1: skip (not hypothesis-meeting)
//
// Output is a unified certificate list.

#include "erdos124/erdos124.hpp"
#include <chrono>
#include <cstdio>
#include <ranges>
#include <string>

using namespace erdos124;

int main(int argc, char** argv) {
    int max_base = 15;
    int min_size = 3;
    int max_size = 5;
    int k_min = 1, k_max = 2;
    int max_cfh = 200;
    double T_start = 10.0, T_max = 1e11;

    for (int i = 1; i < argc; ++i) {
        std::string_view a = argv[i];
        if (a.starts_with("--max-base=")) max_base = std::stoi(std::string(a.substr(11)));
        else if (a.starts_with("--min-size=")) min_size = std::stoi(std::string(a.substr(11)));
        else if (a.starts_with("--max-size=")) max_size = std::stoi(std::string(a.substr(11)));
        else if (a.starts_with("--k-min=")) k_min = std::stoi(std::string(a.substr(8)));
        else if (a.starts_with("--k-max=")) k_max = std::stoi(std::string(a.substr(8)));
        else if (a.starts_with("--T-max=")) T_max = std::stod(std::string(a.substr(8)));
    }

    auto candidates = enumerate::subsets_in_range(max_base, min_size, max_size)
                       | enumerate::coprime_filter()
                       | std::ranges::to<std::vector>();

    std::printf("# unified_batch: max_base=%d, sizes [%d, %d], k in [%d, %d]\n",
                max_base, min_size, max_size, k_min, k_max);
    std::printf("# %zu coprime BaseSets enumerated\n", candidates.size());
    std::printf("# %-30s %-3s %-8s %-7s %-12s %-12s %-12s\n",
                "A", "k", "R", "route", "c*", "T*", "extra");

    int total = 0, strict_ver = 0, exact_ver = 0, fails = 0, skipped = 0;
    auto t0 = std::chrono::high_resolution_clock::now();

    for (const auto& A : candidates) {
        const Real R = A.reciprocal_sum();
        const Regime reg = classify(R);

        for (int k = k_min; k <= k_max; ++k) {
            ++total;
            std::string A_str = A.to_string();

            if (reg == Regime::Strict) {
                auto cert = cfh::search_certificate(A, k, T_start, T_max, max_cfh);
                std::printf("  %-30s %-3d %-8.4Lg %-7s %-12lld %-12llu step=%d %s\n",
                            A_str.c_str(), k, R, "CFH",
                            static_cast<long long>(cert.c_star),
                            static_cast<unsigned long long>(cert.T_star),
                            cert.takeover_step,
                            cert.verified ? "" : "(no cert)");
                if (cert.verified) ++strict_ver; else ++fails;
            } else if (reg == Regime::Exact) {
                auto cert = sunit::search_certificate(A, k, T_start, T_max);
                std::string extra;
                if (cert.indep_pair) {
                    extra = "(" + std::to_string(cert.indep_pair->first) + "," +
                            std::to_string(cert.indep_pair->second) + ")";
                }
                std::printf("  %-30s %-3d %-8.4Lg %-7s %-12lld %-12llu %s %s\n",
                            A_str.c_str(), k, R, "S-unit",
                            static_cast<long long>(cert.c_star),
                            static_cast<unsigned long long>(cert.T_star),
                            extra.c_str(),
                            cert.verified ? "" : "(no cert)");
                if (cert.verified) ++exact_ver; else ++fails;
            } else {
                ++skipped;
            }
        }
    }

    auto t1 = std::chrono::high_resolution_clock::now();
    double dt = std::chrono::duration<double>(t1 - t0).count();

    std::printf("\n# summary:\n");
    std::printf("#   %d (A, k) cases enumerated\n", total);
    std::printf("#   %d strict (CFH) verified\n", strict_ver);
    std::printf("#   %d exact-critical (S-unit) verified qualitatively\n", exact_ver);
    std::printf("#   %d failed\n", fails);
    std::printf("#   %d skipped (R < 1)\n", skipped);
    std::printf("#   %d TOTAL CERTIFIED (Erdős 124 unconditional)\n",
                strict_ver + exact_ver);
    std::printf("#   %.2fs elapsed\n", dt);
    return 0;
}
