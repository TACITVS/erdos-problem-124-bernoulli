#include <iostream>
#include <vector>
#include <cmath>
#include <mpfr.h>
#include <gmpxx.h>
#include <algorithm>
#include <iomanip>
#include <numeric>

using namespace std;

// Compute CF convergents for log(top)/log(bottom)
vector<pair<mpz_class, mpz_class>> cf_convergents(int top, int bottom, int depth, int prec_bits) {
    mpfr_t f_top, f_bot, alpha, a, rest;
    mpfr_init2(f_top, prec_bits);
    mpfr_init2(f_bot, prec_bits);
    mpfr_init2(alpha, prec_bits);
    mpfr_init2(a, prec_bits);
    mpfr_init2(rest, prec_bits);

    mpfr_set_ui(f_top, top, MPFR_RNDN);
    mpfr_log(f_top, f_top, MPFR_RNDN);
    mpfr_set_ui(f_bot, bottom, MPFR_RNDN);
    mpfr_log(f_bot, f_bot, MPFR_RNDN);

    mpfr_div(alpha, f_top, f_bot, MPFR_RNDN);

    vector<pair<mpz_class, mpz_class>> convs;
    mpz_class p_prev2 = 0, p_prev1 = 1;
    mpz_class q_prev2 = 1, q_prev1 = 0;

    for (int i = 0; i < depth; i++) {
        mpfr_floor(a, alpha);
        
        mpz_t a_z;
        mpz_init(a_z);
        mpfr_get_z(a_z, a, MPFR_RNDN);
        mpz_class a_val(a_z);
        mpz_clear(a_z);

        mpz_class p_curr = a_val * p_prev1 + p_prev2;
        mpz_class q_curr = a_val * q_prev1 + q_prev2;
        
        convs.push_back({p_curr, q_curr});
        
        p_prev2 = p_prev1; p_prev1 = p_curr;
        q_prev2 = q_prev1; q_prev1 = q_curr;

        mpfr_sub(rest, alpha, a, MPFR_RNDN);
        if (mpfr_cmp_d(rest, 1e-100) < 0) break;
        mpfr_ui_div(alpha, 1, rest, MPFR_RNDN);
    }

    mpfr_clears(f_top, f_bot, alpha, a, rest, NULL);
    return convs;
}

bool verify_gap(int x, int y, int z, mpz_class ex, mpz_class ey, mpz_class ez, double b_star_log10, int prec_bits) {
    mpfr_t f_x, f_y, f_z, f_ex, f_ey, f_ez, t1, t2, delta1, delta2, min1, min2, gap1, gap2;
    mpfr_inits2(prec_bits, f_x, f_y, f_z, f_ex, f_ey, f_ez, t1, t2, delta1, delta2, min1, min2, gap1, gap2, NULL);
    
    mpfr_set_ui(f_x, x, MPFR_RNDN); mpfr_log(f_x, f_x, MPFR_RNDN);
    mpfr_set_ui(f_y, y, MPFR_RNDN); mpfr_log(f_y, f_y, MPFR_RNDN);
    mpfr_set_ui(f_z, z, MPFR_RNDN); mpfr_log(f_z, f_z, MPFR_RNDN);
    
    mpz_t z_ex, z_ey, z_ez;
    mpz_inits(z_ex, z_ey, z_ez, NULL);
    mpz_set(z_ex, ex.get_mpz_t());
    mpz_set(z_ey, ey.get_mpz_t());
    mpz_set(z_ez, ez.get_mpz_t());
    
    mpfr_set_z(f_ex, z_ex, MPFR_RNDN);
    mpfr_set_z(f_ey, z_ey, MPFR_RNDN);
    mpfr_set_z(f_ez, z_ez, MPFR_RNDN);
    
    mpfr_mul(t1, f_ex, f_x, MPFR_RNDN);
    mpfr_mul(t2, f_ey, f_y, MPFR_RNDN);
    mpfr_sub(delta1, t1, t2, MPFR_RNDN);
    mpfr_abs(delta1, delta1, MPFR_RNDN);
    mpfr_min(min1, t1, t2, MPFR_RNDN);
    
    if (mpfr_cmp_d(delta1, 1e-45) > 0) {
        mpfr_log(delta1, delta1, MPFR_RNDN);
    } else {
        mpfr_set_d(delta1, -50.0 * log(10.0), MPFR_RNDN);
    }
    mpfr_add(gap1, min1, delta1, MPFR_RNDN);
    mpfr_div_d(gap1, gap1, log(10.0), MPFR_RNDN); 
    
    mpfr_mul(t1, f_ey, f_y, MPFR_RNDN);
    mpfr_mul(t2, f_ez, f_z, MPFR_RNDN);
    mpfr_sub(delta2, t1, t2, MPFR_RNDN);
    mpfr_abs(delta2, delta2, MPFR_RNDN);
    mpfr_min(min2, t1, t2, MPFR_RNDN);
    
    if (mpfr_cmp_d(delta2, 1e-45) > 0) {
        mpfr_log(delta2, delta2, MPFR_RNDN);
    } else {
        mpfr_set_d(delta2, -50.0 * log(10.0), MPFR_RNDN);
    }
    mpfr_add(gap2, min2, delta2, MPFR_RNDN);
    mpfr_div_d(gap2, gap2, log(10.0), MPFR_RNDN); 
    
    bool ok = (mpfr_cmp_d(gap1, b_star_log10) > 0) && (mpfr_cmp_d(gap2, b_star_log10) > 0);
    
    mpfr_clears(f_x, f_y, f_z, f_ex, f_ey, f_ez, t1, t2, delta1, delta2, min1, min2, gap1, gap2, NULL);
    mpz_clears(z_ex, z_ey, z_ez, NULL);
    
    return ok;
}

bool mult_indep(int a, int b) {
    if (a == b) return false;
    for (int root = 2; root <= 100; root++) {
        bool a_is_pow = false, b_is_pow = false;
        long long val = root;
        while (val <= 10000) {
            if (val == a) a_is_pow = true;
            if (val == b) b_is_pow = true;
            val *= root;
        }
        if (a_is_pow && b_is_pow) return false;
    }
    return true;
}

long long legendre_threshold(int x, int y, double b_star) {
    for (long long p = 1; ; p++) {
        if (pow(x, (double)p) * log(y) > 4.0 * p * b_star) {
            return p;
        }
        if (p > 10000) return 10000;
    }
}

int main() {
    int depth = 150;
    int prec_bits = 1024;
    double b_star = 1e18;
    double b_star_log10 = log10(b_star);

    cout << "Running CF Intersection search up to depth " << depth << " with MPFR (" << prec_bits << " bits)..." << endl;

    long long tested = 0;
    long long closed_empty = 0;
    long long closed_gap_verified = 0;
    long long failures = 0;

    for (int x = 3; x <= 100; x++) {
        for (int y = x + 1; y <= 100; y++) {
            if (!mult_indep(x, y)) continue;
            auto conv_xy = cf_convergents(y, x, depth, prec_bits);
            long long ml = legendre_threshold(x, y, b_star);
            mpz_class ml_z(to_string(ml));
            mpz_class one_z(1);

            for (int z = y + 1; z <= 100; z++) {
                if (!mult_indep(y, z) || !mult_indep(x, z)) continue;
                auto conv_yz = cf_convergents(z, y, depth, prec_bits);

                tested++;

                vector<mpz_class> intersection;
                bool gap_failed = false;

                for (const auto& c_xy : conv_xy) {
                    mpz_class ex = c_xy.first;
                    mpz_class ey_xy = c_xy.second; // denominator
                    if (ey_xy < ml_z) continue;
                    if (ey_xy == one_z) continue;

                    for (const auto& c_yz : conv_yz) {
                        mpz_class ey_yz = c_yz.first; // numerator
                        mpz_class ez = c_yz.second;
                        
                        if (ey_yz == ey_xy) {
                            intersection.push_back(ey_xy);
                            if (!verify_gap(x, y, z, ex, ey_xy, ez, b_star_log10, prec_bits)) {
                                gap_failed = true;
                            }
                        }
                    }
                }

                if (intersection.empty()) {
                    closed_empty++;
                } else if (!gap_failed) {
                    closed_gap_verified++;
                } else {
                    failures++;
                    cout << "FAILURE for (" << x << ", " << y << ", " << z << ") -> Candidates: ";
                    for (const auto& c : intersection) cout << c.get_str() << " ";
                    cout << endl;
                }
            }
        }
    }

    cout << "Total tested: " << tested << endl;
    cout << "Closed (Empty intersection): " << closed_empty << endl;
    cout << "Closed (Gaps Verified): " << closed_gap_verified << endl;
    cout << "Failures (Unverified Intersection): " << failures << endl;

    return 0;
}
