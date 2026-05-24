import math

def check_entropy(A, T_vals):
    print(f"\n--- Entropy Check for A = {A} ---")
    R = sum(1/(a-1) for a in A)
    print(f"R(A) = {R:.4f}")
    
    # Exponent for subset growth
    exponent = math.log(2) * sum(1/math.log(a) for a in A)
    print(f"Theoretical Exponent: {exponent:.4f} (should be >= 1.2618 if R>=1)")
    
    for T in T_vals:
        # Exact N(T) for k=1
        powers = []
        for a in A:
            e = 1
            while a**e <= T:
                powers.append(a**e)
                e += 1
        N_T = len(powers)
        
        subset_choices = 2**N_T
        T_bound = T**1.2618
        
        print(f"T = {T:<15} | N(T) = {N_T:<4} | 2^N(T) = {subset_choices:<25} | T^1.26 = {T_bound:.2e}")

def check_central_seed_and_bootstrap(A, limit):
    print(f"\n--- Bootstrap Check for A = {A} ---")
    # Generate all channelized powers up to 'limit'
    powers = []
    for a in A:
        e = 1
        while True:
            val = a**e
            if val > limit:
                break
            powers.append((a, e, val))
            e += 1
            
    powers.sort(key=lambda x: x[2])
    
    subset_sums = {0}
    current_sigma = 0
    C = None
    
    for a, e, val in powers:
        new_sums = {s + val for s in subset_sums}
        subset_sums.update(new_sums)
        current_sigma += val
        
        # Check if it has a central radius
        # Since it's symmetric, we just need to find the first hole from the center
        # Center is current_sigma / 2
        
        # This is slow for large sigma, so we only do it for small limits
        if current_sigma < 50000:
            hole_found = False
            for k in range(current_sigma // 2, -1, -1):
                if k not in subset_sums:
                    C = k + 1
                    hole_found = True
                    break
            if not hole_found:
                C = 0
            
            # Print state if we have a seed
            if C is not None and C < current_sigma // 2:
                print(f"Prefix through {val} ({a}^{e}): sigma={current_sigma}, Central Radius C={C}")
                # Bootstrap check: is next power <= sigma - 2C + 1?
                # We can't check next power easily here without looking ahead, but we know C.

if __name__ == "__main__":
    A1 = [3, 4, 7]
    A2 = [3, 4, 8, 43]
    A3 = [3, 4, 5]
    
    T_vals = [10**3, 10**6, 10**9, 10**12, 10**15]
    
    check_entropy(A1, T_vals)
    check_entropy(A2, T_vals)
    check_entropy(A3, T_vals)
    
    print("\n--- Validating Seed Formation ---")
    check_central_seed_and_bootstrap(A1, 1000)
    check_central_seed_and_bootstrap(A3, 5000)
