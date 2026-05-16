#include <algorithm>
#include <cstdint>
#include <iostream>
#include <numeric>
#include <sstream>
#include <stdexcept>
#include <string>
#include <vector>

#include <boost/multiprecision/cpp_int.hpp>

namespace {

using boost::multiprecision::cpp_int;
using u64 = std::uint64_t;

struct Term {
    u64 base;
    u64 exp;
    cpp_int value;
};

struct Args {
    std::vector<u64> bases;
    u64 k = 1;
    u64 seed_limit = 100000;
    u64 conductor = 0;
    u64 steps = 1000;
    std::size_t top = 5;
    u64 target_base = 0;
    u64 target_exp = 0;
};

struct NearMiss {
    cpp_int margin;
    u64 step;
    std::vector<Term> state;
};

std::vector<std::string> split(const std::string& text, char delim) {
    std::vector<std::string> parts;
    std::stringstream ss(text);
    std::string item;
    while (std::getline(ss, item, delim)) {
        if (!item.empty()) {
            parts.push_back(item);
        }
    }
    return parts;
}

std::vector<u64> parse_bases(const std::string& text) {
    std::vector<u64> bases;
    for (const auto& part : split(text, ',')) {
        bases.push_back(std::stoull(part));
    }
    return bases;
}

Args parse_args(int argc, char** argv) {
    Args args;
    for (int i = 1; i < argc; ++i) {
        std::string item(argv[i]);
        auto eq = item.find('=');
        if (eq == std::string::npos) {
            throw std::runtime_error("arguments must use --name=value");
        }
        const std::string key = item.substr(0, eq);
        const std::string value = item.substr(eq + 1);
        if (key == "--bases") {
            args.bases = parse_bases(value);
        } else if (key == "--k") {
            args.k = std::stoull(value);
        } else if (key == "--seed-limit") {
            args.seed_limit = std::stoull(value);
        } else if (key == "--conductor") {
            args.conductor = std::stoull(value);
        } else if (key == "--steps") {
            args.steps = std::stoull(value);
        } else if (key == "--top") {
            args.top = static_cast<std::size_t>(std::stoull(value));
        } else if (key == "--target-base") {
            args.target_base = std::stoull(value);
        } else if (key == "--target-exp") {
            args.target_exp = std::stoull(value);
        } else {
            throw std::runtime_error("unknown argument: " + key);
        }
    }
    if (args.bases.empty()) {
        throw std::runtime_error("--bases is required");
    }
    return args;
}

u64 gcd_u64(u64 a, u64 b) {
    while (b != 0) {
        const u64 r = a % b;
        a = b;
        b = r;
    }
    return a;
}

u64 lcm_u64(u64 a, u64 b) {
    return a / gcd_u64(a, b) * b;
}

cpp_int pow_cpp(u64 base, u64 exp) {
    cpp_int out = 1;
    for (u64 i = 0; i < exp; ++i) {
        out *= base;
    }
    return out;
}

std::vector<Term> first_powers_above(const std::vector<u64>& bases, u64 k, u64 limit) {
    std::vector<Term> frontier;
    for (u64 base : bases) {
        u64 exp = k;
        cpp_int value = pow_cpp(base, exp);
        while (value <= limit) {
            value *= base;
            ++exp;
        }
        frontier.push_back(Term{base, exp, value});
    }
    return frontier;
}

std::vector<u64> powers_upto(const std::vector<u64>& bases, u64 k, u64 limit) {
    std::vector<u64> terms;
    for (u64 base : bases) {
        cpp_int value = pow_cpp(base, k);
        while (value <= limit) {
            terms.push_back(value.convert_to<u64>());
            value *= base;
        }
    }
    std::sort(terms.begin(), terms.end());
    return terms;
}

std::string cpp_to_string(const cpp_int& value) {
    std::ostringstream out;
    out << value;
    return out.str();
}

std::string short_cpp(const cpp_int& value) {
    const std::string text = cpp_to_string(value);
    if (text.size() <= 80) {
        return text;
    }
    return text.substr(0, 35) + "..." + text.substr(text.size() - 35) +
           " (" + std::to_string(text.size()) + " digits)";
}

cpp_int weighted_sum(const std::vector<Term>& frontier, const std::vector<u64>& weights) {
    cpp_int out = 0;
    for (std::size_t i = 0; i < frontier.size(); ++i) {
        out += weights[i] * frontier[i].value;
    }
    return out;
}

std::size_t min_index(const std::vector<Term>& frontier) {
    std::size_t best = 0;
    for (std::size_t i = 1; i < frontier.size(); ++i) {
        if (frontier[i].value < frontier[best].value) {
            best = i;
        }
    }
    return best;
}

void print_state(const std::vector<Term>& frontier) {
    std::cout << "[";
    for (std::size_t i = 0; i < frontier.size(); ++i) {
        if (i != 0) {
            std::cout << ", ";
        }
        std::cout << frontier[i].base << "^" << frontier[i].exp;
    }
    std::cout << "]";
}

void insert_near_miss(std::vector<NearMiss>& misses, NearMiss candidate, std::size_t top) {
    if (top == 0) {
        return;
    }
    misses.push_back(std::move(candidate));
    std::sort(misses.begin(), misses.end(), [](const NearMiss& a, const NearMiss& b) {
        return a.margin < b.margin;
    });
    if (misses.size() > top) {
        misses.pop_back();
    }
}

}  // namespace

int main(int argc, char** argv) {
    try {
        const Args args = parse_args(argc, argv);

        u64 denom = 1;
        for (u64 base : args.bases) {
            denom = lcm_u64(denom, base - 1);
        }
        std::vector<u64> weights;
        u64 weight_sum = 0;
        for (u64 base : args.bases) {
            const u64 weight = denom / (base - 1);
            weights.push_back(weight);
            weight_sum += weight;
        }
        if (weight_sum != denom) {
            throw std::runtime_error("frontier_tail expects an exact-critical reciprocal sum");
        }

        const auto seed = powers_upto(args.bases, args.k, args.seed_limit);
        cpp_int seed_sum = 0;
        for (u64 term : seed) {
            seed_sum += term;
        }
        const cpp_int span = seed_sum - 2 * cpp_int(args.conductor) - 2;
        auto frontier = first_powers_above(args.bases, args.k, args.seed_limit);
        const cpp_int invariant_num = weighted_sum(frontier, weights) - cpp_int(denom) * (span + 1);

        cpp_int current_span = span;
        bool failed = false;
        u64 fail_step = 0;
        cpp_int min_margin;
        u64 min_step = 0;
        std::vector<Term> min_state = frontier;
        bool have_min = false;
        std::vector<NearMiss> near_misses;
        bool stopped_by_target = false;
        u64 actual_steps = 0;

        for (u64 step = 0; step < args.steps; ++step) {
            actual_steps = step + 1;
            const std::size_t idx = min_index(frontier);
            const cpp_int margin = current_span + 1 - frontier[idx].value;
            insert_near_miss(near_misses, NearMiss{margin, step, frontier}, args.top);
            if (!have_min || margin < min_margin) {
                min_margin = margin;
                min_step = step;
                min_state = frontier;
                have_min = true;
            }
            if (margin < 0) {
                failed = true;
                fail_step = step;
                break;
            }

            const cpp_int next_value = frontier[idx].value;
            for (auto& term : frontier) {
                if (term.value == next_value) {
                    current_span += next_value;
                    term.value *= term.base;
                    ++term.exp;
                }
            }
            if (args.target_base != 0) {
                for (const auto& term : frontier) {
                    if (term.base == args.target_base && term.exp > args.target_exp) {
                        stopped_by_target = true;
                        break;
                    }
                }
                if (stopped_by_target) {
                    break;
                }
            }
        }

        std::cout << "{'bases': (";
        for (std::size_t i = 0; i < args.bases.size(); ++i) {
            if (i != 0) {
                std::cout << ", ";
            }
            std::cout << args.bases[i];
        }
        std::cout << "), 'k': " << args.k
                  << ", 'seed_limit': " << args.seed_limit
                  << ", 'conductor': " << args.conductor
                  << ", 'denominator': " << denom
                  << ", 'invariant_num': '" << short_cpp(invariant_num) << "'"
                  << ", 'requested_steps': " << args.steps
                  << ", 'actual_steps': " << actual_steps
                  << ", 'stopped_by_target': " << (stopped_by_target ? "True" : "False")
                  << ", 'failed': " << (failed ? "True" : "False")
                  << ", 'fail_step': ";
        if (failed) {
            std::cout << fail_step;
        } else {
            std::cout << "None";
        }
        std::cout << ", 'min_step': " << min_step
                  << ", 'min_margin': '" << short_cpp(min_margin) << "'"
                  << ", 'min_state': '";
        print_state(min_state);
        std::cout << "', 'final_state': '";
        print_state(frontier);
        std::cout << "', 'near_misses': [";
        for (std::size_t i = 0; i < near_misses.size(); ++i) {
            if (i != 0) {
                std::cout << ", ";
            }
            std::cout << "{'step': " << near_misses[i].step
                      << ", 'margin': '" << short_cpp(near_misses[i].margin)
                      << "', 'state': '";
            print_state(near_misses[i].state);
            std::cout << "'}";
        }
        std::cout << "]}\n";
    } catch (const std::exception& ex) {
        std::cerr << "error: " << ex.what() << "\n";
        return 2;
    }
    return 0;
}
