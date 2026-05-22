// conductor_scan_v2.cpp — conductor scan driver using erdos124 library.
//
// Functional pipeline: parse args -> build BaseSet -> for each T compute
// conductor -> format output.

#include "erdos124/erdos124.hpp"
#include <cstdio>
#include <ranges>
#include <string>
#include <vector>

using namespace erdos124;

namespace {

std::vector<int> parse_int_list(std::string_view s) {
    std::vector<int> out;
    std::size_t pos = 0;
    while (pos < s.size()) {
        auto next = s.find(',', pos);
        auto token = s.substr(pos, next - pos);
        if (!token.empty()) out.push_back(std::stoi(std::string(token)));
        if (next == std::string_view::npos) break;
        pos = next + 1;
    }
    return out;
}

std::vector<double> parse_double_list(std::string_view s) {
    std::vector<double> out;
    std::size_t pos = 0;
    while (pos < s.size()) {
        auto next = s.find(',', pos);
        auto token = s.substr(pos, next - pos);
        if (!token.empty()) out.push_back(std::stod(std::string(token)));
        if (next == std::string_view::npos) break;
        pos = next + 1;
    }
    return out;
}

} // namespace

int main(int argc, char** argv) {
    std::vector<int> bases;
    int k = 1;
    std::vector<double> Ts;

    for (int i = 1; i < argc; ++i) {
        std::string_view a = argv[i];
        if (a.starts_with("--bases=")) bases = parse_int_list(a.substr(8));
        else if (a.starts_with("--k=")) k = std::stoi(std::string(a.substr(4)));
        else if (a.starts_with("--T-list=")) Ts = parse_double_list(a.substr(9));
    }

    if (bases.empty() || Ts.empty()) {
        std::fprintf(stderr,
            "usage: %s --bases=3,4,7 --k=1 --T-list=1e3,1e4,1e5\n", argv[0]);
        return 1;
    }

    BaseSet A(bases);
    std::printf("# conductor_scan_v2: A = %s, k = %d\n", A.to_string().c_str(), k);
    std::printf("# %-10s %-12s %-14s %-12s %-10s %-6s\n",
                "T", "T_min", "S", "c(E)", "c/T", "|F|");

    for (double T : Ts) {
        BalancedFrontier E(A, T);
        Seed F(A, E, k);
        auto cr = compute_conductor(F);
        if (!cr) {
            std::printf("  %-10.2e  ERROR: %s\n", T, cr.error().c_str());
            continue;
        }
        const double ratio = static_cast<double>(cr->conductor) /
                              static_cast<double>(E.T_min());
        std::printf("  %-10.2e  %-12llu  %-14llu  %-12lld  %-10.4f %-6zu\n",
                    T,
                    static_cast<unsigned long long>(E.T_min()),
                    static_cast<unsigned long long>(cr->S),
                    static_cast<long long>(cr->conductor),
                    ratio,
                    F.size());
    }
    return 0;
}
