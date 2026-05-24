import sympy as sp

def validate_equality_cores():
    print("--- 1. Validating the {3,4,x,y} Equality Cores ---")
    x, y = sp.symbols('x y', integer=True, positive=True)
    
    # The equality condition: R(A) = 1
    # 1/(3-1) + 1/(4-1) + 1/(x-1) + 1/(y-1) = 1
    # 1/2 + 1/3 + 1/(x-1) + 1/(y-1) = 1
    # 1/(x-1) + 1/(y-1) = 1/6
    
    eq = sp.Eq(1/(x-1) + 1/(y-1), sp.Rational(1, 6))
    print(f"Equation: {eq}")
    
    # Rearranging: 6(x-1 + y-1) = (x-1)(y-1)
    # (x-1)(y-1) - 6x - 6y + 12 = 0
    # xy - 7x - 7y + 13 = 0
    # (x-7)(y-7) = 36
    
    solutions = []
    # We look for factors of 36
    for d in sp.divisors(36):
        x_val = d + 7
        y_val = (36 // d) + 7
        
        # We only care about x < y to avoid symmetry and x, y >= 5
        if x_val < y_val and x_val >= 5:
            solutions.append((x_val, y_val))
            
    print(f"Algebraic Solutions for (x,y): {solutions}")
    expected = [(8, 43), (9, 25), (10, 19), (11, 16)]
    assert solutions == expected, "Mismatch in critical cores!"
    print("-> VALIDATED: The 4 equality cores are mathematically exhaustive.")

def validate_geometric_series_identity():
    print("\n--- 2. Validating the Sigma Identity ---")
    a = sp.Symbol('a', integer=True, positive=True)
    # Since a >= 3, a != 1
    k, N, t = sp.symbols('k N t', integer=True, positive=True)
    
    # E_a is the next unused power = a^N
    E_a = a**N
    
    # The sum of powers from e=k to N-1
    # sum_{e=k}^{N-1} a^e
    sum_expr = sp.Sum(a**k * a**sp.Symbol('i'), (sp.Symbol('i'), 0, N - 1 - k)).doit()
    # sum_expr simplifies to (a^N - a^k) / (a-1)
    
    expected_sum = (E_a - a**k) / (a - 1)
    diff = sp.simplify(sum_expr - expected_sum)
    # If it evaluates to Piecewise, extract the True case
    if isinstance(diff, sp.Piecewise):
        diff = diff.subs(a > 1, True).simplify()
    if isinstance(diff, sp.Piecewise):
        diff = diff.args[-1][0] # Get the default fallback value which is 0 for a!=1
    
    print(f"Sum expression simplified difference from expected: {diff}")
    assert diff == 0, "Geometric series identity failed!"
    print("-> VALIDATED: sigma_a = (E_a - a^k) / (a-1)")

def validate_exact_failure_identity():
    print("\n--- 3. Validating the Exact Bottleneck Identity ---")
    # We want to verify:
    # sigma - t = (R(A)-1)t + sum((E_a - t)/(a-1)) - C_0
    
    # Let's do it for 3 arbitrary bases a, b, c
    a, b, c, t, k = sp.symbols('a b c t k')
    E_a, E_b, E_c = sp.symbols('E_a E_b E_c')
    
    # Definitions
    sigma = (E_a - a**k)/(a-1) + (E_b - b**k)/(b-1) + (E_c - c**k)/(c-1)
    R_A = 1/(a-1) + 1/(b-1) + 1/(c-1)
    C_0 = a**k/(a-1) + b**k/(b-1) + c**k/(c-1)
    
    # RHS of the identity
    rhs = (R_A - 1)*t + (E_a - t)/(a-1) + (E_b - t)/(b-1) + (E_c - t)/(c-1) - C_0
    
    # Check if sigma - t == rhs
    lhs = sigma - t
    difference = sp.simplify(lhs - rhs)
    
    print(f"LHS (sigma - t) : {lhs}")
    print(f"RHS             : {rhs}")
    print(f"Difference      : {difference}")
    assert difference == 0, "Exact bottleneck identity failed!"
    print("-> VALIDATED: The critical failure inequality is algebraically exact.")

if __name__ == "__main__":
    validate_equality_cores()
    validate_geometric_series_identity()
    validate_exact_failure_identity()
