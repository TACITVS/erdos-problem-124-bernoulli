// library_smoke_test.cpp — verify that the library produces identical
// results to the legacy standalone code, on a few sanity-check cases.

#include "erdos124/erdos124.hpp"
#include <cstdio>

using namespace erdos124;

int main() {
    std::printf("# erdos124 library smoke test\n");

    // Test 1: BaseSet basics.
    BaseSet A({3, 4, 5});
    std::printf("\n[test 1] BaseSet A = %s\n", A.to_string().c_str());
    std::printf("  gcd          = %d\n", A.gcd());
    std::printf("  R(A)         = %.6Lf  (13/12 expected)\n", A.reciprocal_sum());
    std::printf("  marstrand    = %.6Lf\n", A.marstrand_sum());

    // Test 2: Conductor for {3,4,7} k=1 at T = 10^4 should be 581.
    BaseSet A347({3, 4, 7});
    auto cr = conductor_at_T(A347, 1, 1e4);
    if (cr) {
        std::printf("\n[test 2] {3,4,7} k=1 T=1e4: c = %lld  (581 expected)\n",
                    static_cast<long long>(cr->conductor));
    } else {
        std::printf("\n[test 2] conductor failed: %s\n", cr.error().c_str());
    }

    // Test 3: CFH-strict for {3,4,5} k=1 should verify with c* = 79.
    auto cert = cfh::search_certificate(BaseSet({3, 4, 5}), 1);
    std::printf("\n[test 3] CFH-strict {3,4,5} k=1: %s\n",
                cert.verified ? "VERIFIED" : "no");
    if (cert.verified) {
        std::printf("  c* = %lld (79 expected), T* = %llu, takeover at step %d\n",
                    static_cast<long long>(cert.c_star),
                    static_cast<unsigned long long>(cert.T_star),
                    cert.takeover_step);
    }

    // Test 4: I(T) for {3,4,7} should be ~1.23 at large T.
    Real IT = I_T(A347, 1e5, 60, 100000LL, 100000000LL);
    std::printf("\n[test 4] I(1e5) for {3,4,7}: %.4Lf  (1.23 expected)\n", IT);

    // Test 5: L_2 for {3,4,5} at T = 100.
    BalancedFrontier E(A, 100);
    Seed F(A, E, 1);
    auto l2 = compute_L2(F);
    if (l2) {
        Real T = static_cast<Real>(E.T_min());
        std::printf("\n[test 5] L_2 for {3,4,5} k=1 T=100: %.6Le, T*L_2 = %.4Lf\n",
                    *l2, T * *l2);
    }

    // Test 6: MW machinery.
    std::printf("\n[test 6] MW for (3, 4):\n");
    std::printf("  mult-indep = %s\n",
                mw::multiplicatively_independent(3, 4) ? "yes" : "no");
    std::printf("  C(3, 4)    = %.4Lf\n", mw::mw_constant(3, 4));
    std::printf("  |3^10 - 4^?| lower bound = %.4Le\n",
                mw::separation_lower_bound(3, 4, 10, 8));

    // Test 7: Diophantine transversality coefficient.
    std::printf("\n[test 7] Transversality coefficient:\n");
    std::printf("  K({3,4,5})      = %.4Lf\n",
                diophantine::transversality_coefficient(BaseSet({3, 4, 5})));
    std::printf("  K({3,4,7})      = %.4Lf\n",
                diophantine::transversality_coefficient(BaseSet({3, 4, 7})));
    std::printf("  K({3,4,9,25})   = %.4Lf\n",
                diophantine::transversality_coefficient(BaseSet({3, 4, 9, 25})));

    // Test 8: Enumeration.
    auto strict_set = enumerate::subsets_in_range(7, 3, 4)
                       | enumerate::coprime_filter()
                       | enumerate::strict_filter()
                       | std::ranges::to<std::vector>();
    std::printf("\n[test 8] Strict hypothesis-meeting subsets of {3..7} size 3-4:\n");
    for (const auto& A_i : strict_set) {
        std::printf("  %s  R = %.4Lf\n", A_i.to_string().c_str(),
                    A_i.reciprocal_sum());
    }

    std::printf("\n# Smoke test complete.\n");
    return 0;
}
