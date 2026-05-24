import itertools

def get_powers(A, max_k):
    powers = []
    for a in A:
        for j in range(1, max_k + 1):
            powers.append((a**j, a, j))
    powers.sort(key=lambda x: x[0])
    return [p[0] for p in powers]

def get_subset_sums(elements):
    sums = {0}
    for e in elements:
        sums |= {s + e for s in sums}
    return sorted(list(sums))

def get_max_gap(sums):
    if len(sums) < 2: return 0
    return max(sums[i] - sums[i-1] for i in range(1, len(sums))) - 1

def analyze_block_sum(A, K, M):
    print(f"\nAnalyzing Block-Sum for A={A}, K={K}, M={M}")
    
    all_powers = get_powers(A, M)
    
    # P_low: powers up to base^K
    max_low = max(a**K for a in A)
    P_low = [p for p in all_powers if p <= max_low]
    
    # P_high: powers from base^K to base^M
    P_high = [p for p in all_powers if p > max_low]
    
    print(f"|P_low| = {len(P_low)}, max(P_low) = {max(P_low) if P_low else 0}")
    print(f"|P_high| = {len(P_high)}, min(P_high) = {min(P_high) if P_high else 0}")
    
    Sigma_low = get_subset_sums(P_low)
    H = get_max_gap(Sigma_low)
    S_low = Sigma_low[-1]
    print(f"Sigma_low: max sum = {S_low}, max gap = {H}")
    
    Sigma_high = get_subset_sums(P_high)
    print(f"Sigma_high: {len(Sigma_high)} shift points")
    
    # Full sumset
    Sigma_M = get_subset_sums(all_powers)
    
    # Find longest interval in Sigma_M
    max_len = 0
    current_start = Sigma_M[0]
    current_len = 1
    
    for i in range(1, len(Sigma_M)):
        if Sigma_M[i] == Sigma_M[i-1] + 1:
            current_len += 1
        else:
            if current_len > max_len:
                max_len = current_len
            current_len = 1
    if current_len > max_len:
        max_len = current_len
        
    print(f"Sigma_M longest interval length = {max_len}")
    
    # Check if length >= next power
    next_power = min(a**(M+1) for a in A)
    print(f"Next power = {next_power}")
    if max_len >= next_power:
        print(">>> MOVING INTERVAL BOOTSTRAP TRIGGERED!")

if __name__ == "__main__":
    analyze_block_sum([3, 4, 5], 2, 4)
    analyze_block_sum([3, 4, 5], 3, 5)
