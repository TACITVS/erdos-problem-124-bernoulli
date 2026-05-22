---
name: Use C++ instead of Python for heavy numerical computation
description: For subset-sum bitscans, Fourier integrals, and other hot numeric loops, write a C++ binary first. Reach for Python only if it has an exclusive library with no C++ equivalent (rare).
type: feedback
originSessionId: 5599ce40-2544-40b3-bf40-5abf9975f171
---
For heavy numerical loops (subset-sum bitscans, Fourier integrals, conductor computations, lattice scans, anything with an inner loop running 10^7+ times), **write a C++ binary, not a Python script**.

**Why:** Empirically observed 50-100× speedup in this project. `cpp/bernoulli_fourier.cpp` (OpenMP-parallel cosine product) is ~50× faster than the equivalent SymPy/numpy script. `cpp/conductor_scan.cpp` (uint64 shift-OR bitset) completes a case at S = 2×10⁸ in 0.5s where the Python version was taking minutes. The asymptotic ranges we care about (T = 10⁷–10⁹ for conductor scans) are simply not feasible in Python at session-friendly latencies.

**How to apply:**
- Default to C++ for any numerical hot-loop work in this project.
- Build flags: `g++ -O3 -fopenmp -std=c++20 -march=native` (drop `-fopenmp` if no parallelism).
- For Windows: requires `C:\msys64\mingw64\bin` on PATH at run-time (libgomp-1.dll); Python subprocess drivers must prepend this to PATH.
- Use Python only for orchestration (driving the C++ binary, parsing output, plotting, small symbolic checks) and only when no C++ binding exists for the library you need.

**Exception (rare):** If a task genuinely needs a library that has no C++ equivalent (e.g., a specific SymPy algebraic manipulation, a niche stats library, mpmath-style arbitrary-precision specialty), Python is fine. But for anything that boils down to "shift bits / multiply / sum / loop", C++ wins decisively.

**When the user catches me using Python for a hot loop:** apologize briefly, port to C++, move on. Don't argue.
