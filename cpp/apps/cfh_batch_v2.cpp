// cfh_batch_v2.cpp — batch CFH-strict certifier using erdos124 library.
//
// Declarative pipeline: enumerate subsets -> filter strict -> verify
// each -> tally results.

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
    int max_cfh_steps = 200;
    double T_start = 10.0, T_max = 1e11;

    for (int i = 1; i < argc; ++i) {
        std::string_view a = argv[i];
        if (a.starts_with("--max-base=")) max_base = std::stoi(std::string(a.substr(11)));
        else if (a.starts_with("--min-size=")) min_size = std::stoi(std::string(a.substr(11)));
        else if (a.starts_with("--max-size=")) max_size = std::stoi(std::string(a.substr(11)));
        else if (a.starts_with("--k-min=")) k_min = std::stoi(std::string(a.substr(8)));
        else if (a.starts_with("--k-max=")) k_max = std::stoi(std::string(a.substr(8)));
        else if (a.starts_with("--max-cfh=")) max_cfh_steps = std::stoi(std::string(a.substr(10)));
        else if (a.starts_with("--T-start=")) T_start = std::stod(std::string(a.substr(10)));
        else if (a.starts_with("--T-max=")) T_max = std::stod(std::string(a.substr(8)));
    }

    auto strict_candidates = enumerate::subsets_in_range(max_base, min_size, max_size)
                              | enumerate::coprime_filter()
                              | enumerate::strict_filter()
                              | std::ranges::to<std::vector>();

    std::printf("# cfh_batch_v2: max_base=%d, sizes [%d, %d], k in [%d, %d]\n",
                max_base, min_size, max_size, k_min, k_max);
    std::printf("# enumerated %zu strict hypothesis-meeting BaseSets\n",
                strict_candidates.size());
    std::printf("# %-30s %-3s %-8s %-12s %-12s %-6s\n",
                "A", "k", "R", "c*", "T*", "step");

    int total = 0, verified = 0;
    auto t0 = std::chrono::high_resolution_clock::now();

    for (const auto& A : strict_candidates) {
        for (int k = k_min; k <= k_max; ++k) {
            ++total;
            auto cert = cfh::search_certificate(A, k, T_start, T_max, max_cfh_steps);
            std::printf("  %-30s %-3d %-8.4Lg %-12lld %-12llu %-6d %s\n",
                        A.to_string().c_str(), k, A.reciprocal_sum(),
                        static_cast<long long>(cert.c_star),
                        static_cast<unsigned long long>(cert.T_star),
                        cert.takeover_step,
                        cert.verified ? "" : "(no cert)");
            if (cert.verified) ++verified;
        }
    }

    auto t1 = std::chrono::high_resolution_clock::now();
    double dt = std::chrono::duration<double>(t1 - t0).count();

    std::printf("\n# summary: %d cases tested\n", total);
    std::printf("#          %d verified\n", verified);
    std::printf("#          %d failed\n", total - verified);
    std::printf("#          %.2fs elapsed\n", dt);
    return 0;
}
