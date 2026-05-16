# C++ accelerators

`erdos124_fast.cpp` is a focused accelerator for exact subset-sum bitset
searches.  Python remains the proof/CAS orchestration layer; this binary is for
large conductor and central-interval scans.

`frontier_tail.cpp` is the exact big-integer scanner for exact-critical tail
frontier states after a central interval has been found.

Build:

```text
g++ -O3 -std=c++20 -march=native cpp/erdos124_fast.cpp -o cpp/erdos124_fast.exe
g++ -O3 -std=c++20 -march=native cpp/frontier_tail.cpp -o cpp/frontier_tail.exe
```

Examples:

```text
cpp/erdos124_fast.exe --mode=conductor --bases=3,4,7 --k=1 --limit=100000
cpp/erdos124_fast.exe --mode=central --bases=3,4,7 --k=2 --seed-limit=50000000
cpp/frontier_tail.exe --bases=3,4,7 --k=2 --seed-limit=50000000 --conductor=3982888 --target-base=3 --target-exp=293904 --steps=1000000
```
