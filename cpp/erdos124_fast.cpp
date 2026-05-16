#include <algorithm>
#include <cstdint>
#include <cstdlib>
#include <iostream>
#include <numeric>
#include <sstream>
#include <stdexcept>
#include <string>
#include <vector>

namespace {

using u64 = std::uint64_t;

struct Args {
    std::string mode = "conductor";
    std::vector<u64> bases;
    u64 k = 1;
    u64 limit = 100000;
    u64 seed_limit = 0;
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
        std::string key = item.substr(0, eq);
        std::string value = item.substr(eq + 1);
        if (key == "--mode") {
            args.mode = value;
        } else if (key == "--bases") {
            args.bases = parse_bases(value);
        } else if (key == "--k") {
            args.k = std::stoull(value);
        } else if (key == "--limit") {
            args.limit = std::stoull(value);
        } else if (key == "--seed-limit") {
            args.seed_limit = std::stoull(value);
        } else {
            throw std::runtime_error("unknown argument: " + key);
        }
    }
    if (args.bases.empty()) {
        throw std::runtime_error("--bases is required");
    }
    if (args.seed_limit == 0) {
        args.seed_limit = args.limit;
    }
    return args;
}

u64 checked_pow_upto(u64 base, u64 exp, u64 cap) {
    u64 out = 1;
    for (u64 i = 0; i < exp; ++i) {
        if (out > cap / base) {
            return cap + 1;
        }
        out *= base;
    }
    return out;
}

std::vector<u64> powers_upto(const std::vector<u64>& bases, u64 k, u64 limit) {
    std::vector<u64> terms;
    for (u64 d : bases) {
        u64 p = checked_pow_upto(d, k, limit);
        while (p <= limit) {
            terms.push_back(p);
            if (p > limit / d) {
                break;
            }
            p *= d;
        }
    }
    std::sort(terms.begin(), terms.end());
    return terms;
}

class Bitset {
public:
    explicit Bitset(u64 max_value) : nbits_(max_value + 1), words_((nbits_ + 63) / 64, 0) {
        words_[0] = 1;
        mask_tail();
    }

    void add_shift(u64 shift) {
        if (shift >= nbits_) {
            return;
        }
        const std::size_t word_shift = static_cast<std::size_t>(shift / 64);
        const unsigned bit_shift = static_cast<unsigned>(shift % 64);
        for (std::size_t i = words_.size(); i-- > 0;) {
            u64 shifted = 0;
            if (i >= word_shift) {
                const std::size_t src = i - word_shift;
                shifted = words_[src] << bit_shift;
                if (bit_shift != 0 && src > 0) {
                    shifted |= words_[src - 1] >> (64 - bit_shift);
                }
            }
            words_[i] |= shifted;
        }
        mask_tail();
    }

    struct MissingStats {
        u64 count = 0;
        bool has_last = false;
        u64 last = 0;
        std::vector<u64> tail;
    };

    MissingStats missing_stats() const {
        MissingStats stats;
        std::vector<u64> reverse_tail;
        for (std::size_t i = 0; i < words_.size(); ++i) {
            const u64 valid = valid_mask(i);
            const u64 zeros = (~words_[i]) & valid;
            stats.count += static_cast<u64>(__builtin_popcountll(zeros));
        }
        for (std::size_t i = words_.size(); i-- > 0 && reverse_tail.size() < 10;) {
            u64 zeros = (~words_[i]) & valid_mask(i);
            while (zeros != 0 && reverse_tail.size() < 10) {
                const int bit = 63 - __builtin_clzll(zeros);
                const u64 pos = static_cast<u64>(i) * 64 + static_cast<u64>(bit);
                reverse_tail.push_back(pos);
                zeros &= ~(u64{1} << bit);
            }
        }
        if (!reverse_tail.empty()) {
            stats.has_last = true;
            stats.last = reverse_tail.front();
            stats.tail.assign(reverse_tail.rbegin(), reverse_tail.rend());
        }
        return stats;
    }

private:
    u64 nbits_;
    std::vector<u64> words_;

    u64 valid_mask(std::size_t index) const {
        if (index + 1 != words_.size()) {
            return ~u64{0};
        }
        const unsigned used = static_cast<unsigned>(nbits_ % 64);
        if (used == 0) {
            return ~u64{0};
        }
        return (u64{1} << used) - 1;
    }

    void mask_tail() {
        words_.back() &= valid_mask(words_.size() - 1);
    }
};

void print_tail(const std::vector<u64>& tail) {
    std::cout << "(";
    for (std::size_t i = 0; i < tail.size(); ++i) {
        if (i != 0) {
            std::cout << ", ";
        }
        std::cout << tail[i];
    }
    std::cout << ")";
}

void run_conductor(const Args& args) {
    auto terms = powers_upto(args.bases, args.k, args.limit);
    Bitset bits(args.limit);
    for (u64 term : terms) {
        bits.add_shift(term);
    }
    auto stats = bits.missing_stats();

    std::cout << "{'mode': 'conductor', 'bases': (";
    for (std::size_t i = 0; i < args.bases.size(); ++i) {
        if (i != 0) {
            std::cout << ", ";
        }
        std::cout << args.bases[i];
    }
    std::cout << "), 'k': " << args.k << ", 'limit': " << args.limit
              << ", 'terms': " << terms.size()
              << ", 'missing_count': " << stats.count << ", 'last_missing': ";
    if (stats.has_last) {
        std::cout << stats.last;
    } else {
        std::cout << "None";
    }
    std::cout << ", 'tail': ";
    print_tail(stats.tail);
    std::cout << "}\n";
}

void run_central(const Args& args) {
    auto seed = powers_upto(args.bases, args.k, args.seed_limit);
    const u64 seed_sum = std::accumulate(seed.begin(), seed.end(), u64{0});
    const u64 half = seed_sum / 2;
    Bitset bits(half);
    for (u64 term : seed) {
        bits.add_shift(term);
    }
    auto stats = bits.missing_stats();
    const u64 conductor = stats.has_last ? stats.last : static_cast<u64>(-1);

    std::cout << "{'mode': 'central', 'bases': (";
    for (std::size_t i = 0; i < args.bases.size(); ++i) {
        if (i != 0) {
            std::cout << ", ";
        }
        std::cout << args.bases[i];
    }
    std::cout << "), 'k': " << args.k << ", 'seed_limit': " << args.seed_limit
              << ", 'terms': " << seed.size()
              << ", 'seed_sum': " << seed_sum
              << ", 'half': " << half
              << ", 'missing_count_to_half': " << stats.count
              << ", 'conductor_to_half': ";
    if (stats.has_last) {
        std::cout << conductor;
    } else {
        std::cout << "None";
    }
    if (stats.has_last) {
        std::cout << ", 'central_interval': (" << (conductor + 1) << ", "
                  << (seed_sum - conductor - 1) << ")";
    }
    std::cout << ", 'tail': ";
    print_tail(stats.tail);
    std::cout << "}\n";
}

}  // namespace

int main(int argc, char** argv) {
    try {
        const Args args = parse_args(argc, argv);
        if (args.mode == "conductor") {
            run_conductor(args);
        } else if (args.mode == "central") {
            run_central(args);
        } else {
            throw std::runtime_error("unknown mode: " + args.mode);
        }
    } catch (const std::exception& ex) {
        std::cerr << "error: " << ex.what() << "\n";
        return 2;
    }
    return 0;
}

