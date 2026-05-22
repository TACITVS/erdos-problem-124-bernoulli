---
name: Use the erdos124 C++23 library, don't write scattered standalone code
description: For new C++ computation in this project, add capabilities as modules in the cpp/include/erdos124/ header-only library, not as standalone .cpp files duplicating machinery.
type: feedback
originSessionId: 5599ce40-2544-40b3-bf40-5abf9975f171
---
The project has a clean C++23 header-only library at
`cpp/include/erdos124/` (notes 80, 81).  It provides:

- `types.hpp` — BaseSet, Regime, concepts (immutable)
- `frontier.hpp` — BalancedFrontier, Seed
- `conductor.hpp` — compute_conductor (half-bitset), compute_L2
- `fourier.hpp` — hat_mu_squared, I_T (OpenMP)
- `cfh.hpp` — CFH-strict certifier (Theorem A of note 72)
- `sunit.hpp` — S-unit qualitative certifier (Theorem B of note 72)
- `mw.hpp` — Mignotte-Waldschmidt effective bounds
- `diophantine.hpp` — DGS+MW analysis (note 79)
- `enumerate.hpp` — Declarative subset enumeration with filters
- `erdos124.hpp` — umbrella include

Apps live in `cpp/apps/` and use the library: conductor_scan_v2,
cfh_batch_v2, sunit (in unified_batch), dgs_explore, unified_batch.

Build via CMake (cpp/CMakeLists.txt).

**Why:** Earlier the project had ~7 scattered standalone .cpp files
(`cpp/conductor_scan.cpp`, `cpp/cfh_batch.cpp`, `cpp/sunit_general.cpp`,
etc.) each duplicating bitset, Fourier, and seed-building code.  The
user pushed back: "don't write 'one off' scattered around C++ code,
build an API or library where modules will be added as we need more
capabilities, make it all integrated and easy to use, use all the most
powerful capabilities of C++23 and write it in a more declarative
functional programming immutable style".  Note 80 + 81 delivered this.

**How to apply:**
- For a new capability: add `cpp/include/erdos124/{name}.hpp`, include
  it in `erdos124.hpp`, and write the driver in `cpp/apps/{name}.cpp`
  using the library.  Do NOT add to the legacy scattered .cpp files.
- Use C++23 features: `std::expected` (error handling), `std::ranges`,
  `std::span`, designated initializers, concepts.
- Functional immutable style for public APIs; imperative inner loops
  hidden behind functional interfaces.
- Header-only.  No separate .cpp files needed for the library itself.

**Legacy code** (the standalone `cpp/*.cpp` files) continues to work
but is superseded.  Don't extend it; port any new analyses to the
library form.

**When the user requests new computation:** check if it fits an
existing module (add a function) or needs a new module (add a header).
Then add an `apps/` driver if needed.
