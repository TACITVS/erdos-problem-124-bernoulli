// dgs_explore.cpp — exploration tool for the DGS + MW attack direction
// (note 79).
//
// For specified base sets, computes:
//  - The transversality coefficient K(A) (max Diophantine exponent over
//    mult-indep pairs).
//  - The empirical zero separation of hat mu_A near various scales R.
//  - The empirical L^2 density at zero proxy (Gaussian-weighted Fourier
//    integral).
//  - The I_infty empirical value (cross-check with notes 60-62).
//
// Purpose: gather quantitative evidence on whether the proposed DGS+MW
// bridge has the right form to give L^2 density of mu_A.

#include "erdos124/erdos124.hpp"
#include <chrono>
#include <cstdio>
#include <ranges>
#include <string>

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

} // namespace

int main(int argc, char** argv) {
    std::vector<std::vector<int>> default_cases = {
        {3, 4, 5},
        {3, 4, 7},
        {3, 4, 9, 25},
        {3, 5, 7, 13},
        {4, 5, 6, 7, 21},
    };
    std::vector<BaseSet> cases;
    for (int i = 1; i < argc; ++i) {
        std::string_view a = argv[i];
        if (a.starts_with("--bases=")) {
            cases.emplace_back(parse_int_list(a.substr(8)));
        }
    }
    if (cases.empty()) {
        for (auto& v : default_cases) cases.emplace_back(v);
    }

    std::printf("# dgs_explore: DGS+MW direction diagnostics (note 79)\n\n");

    for (const auto& A : cases) {
        std::printf("==== A = %s ====\n", A.to_string().c_str());
        std::printf("  R(A) = %.6Lf  (regime: %s)\n",
                    A.reciprocal_sum(),
                    classify(A.reciprocal_sum()) == Regime::Strict ? "strict" :
                    classify(A.reciprocal_sum()) == Regime::Exact ? "exact" : "fails");
        std::printf("  marstrand sum 1/log_2 a = %.6Lf\n", A.marstrand_sum());

        // MW: transversality coefficient K(A).
        Real K = diophantine::transversality_coefficient(A);
        std::printf("  K(A) (max Diophantine exponent) = %.4Lf\n", K);

        // Multiplicatively-independent pair.
        auto pair = mw::find_indep_pair(A);
        if (pair) {
            std::printf("  Indep pair: (%d, %d), MW const C = %.4Lf\n",
                        pair->first, pair->second,
                        mw::mw_constant(pair->first, pair->second));
        } else {
            std::printf("  No mult-indep pair (A is mult-dependent)\n");
        }

        // Empirical zero separation at several scales.
        std::printf("  Zero separation at scales:\n");
        for (Real R : {1e3L, 1e4L, 1e5L, 1e6L}) {
            Real sep = diophantine::empirical_min_separation(A, R, 200);
            std::printf("    R = %.0Le:  min |z_i - z_{i+1}| = %.4Le\n", R, sep);
        }

        // Autocorrelation density at 0 = I_infty / (2 pi).  This is the
        // RIGHT density-at-zero quantity (g_0 of mu_A * tilde mu_A).
        // Should converge to a positive finite limit iff BC L^2 holds.
        std::printf("  Autocorrelation density g_0(T) = I_T / (2*pi):\n");
        for (double T : {1e3, 1e4, 1e5, 1e6}) {
            auto t0 = std::chrono::high_resolution_clock::now();
            Real g0 = diophantine::autocorrelation_density_at_zero(A, T);
            auto t1 = std::chrono::high_resolution_clock::now();
            double dt = std::chrono::duration<double>(t1 - t0).count();
            std::printf("    T = %.0e:  g_0 = %.6Lf  (time %.2fs)\n", T, g0, dt);
        }

        std::printf("\n");
    }

    return 0;
}
