# CMakeLists.txt — erdos124 C++23 library + apps.
#
# Build:
#   mkdir -p build && cd build
#   cmake -DCMAKE_BUILD_TYPE=Release ..
#   cmake --build . -j
#
# Produces apps in build/apps/ (e.g., build/apps/conductor_scan).

cmake_minimum_required(VERSION 3.20)
project(erdos124 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release)
endif()

# Aggressive optimizations for hot inner loops.
add_compile_options(-O3 -march=native -Wall -Wextra -pedantic)

# OpenMP for Fourier integration and inner-loop parallelism.
find_package(OpenMP)

# Header-only interface library.
add_library(erdos124 INTERFACE)
target_include_directories(erdos124 INTERFACE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
)
if(OpenMP_CXX_FOUND)
    target_link_libraries(erdos124 INTERFACE OpenMP::OpenMP_CXX)
endif()

# Apps — each is a separate executable using the library.
function(add_erdos124_app name)
    add_executable(${name} apps/${name}.cpp)
    target_link_libraries(${name} PRIVATE erdos124)
endfunction()

add_erdos124_app(conductor_scan_v2)
add_erdos124_app(cfh_batch_v2)
add_erdos124_app(dgs_explore)
add_erdos124_app(library_smoke_test)
add_erdos124_app(unified_batch)
add_erdos124_app(cf_intersection)
