use lib 'raku/lib';
use Erdos124::ResidueDSL;

sub check(Bool $condition, Str $message) {
    die "[FAIL] $message" unless $condition;
}

sub report(Str $title, *@lines) {
    say "case: $title";
    for @lines -> $line {
        say "  $line";
    }
    say "";
}

my $mod6 = modulus(6);
check(17 ≡ₘ modulo(5, $mod6), "custom congruence operator failed");

my $frame_347 = residue-frame($mod6, [0, 7, 14, 3, 4, 11]);
my $ray_347 = multiple-ray($mod6, 6000);
my $interval_347 = multiple-interval($mod6, 6000, 6060);
my $lifted_ray_347 = lift($frame_347, $ray_347);
my $lifted_interval_347 = lift($frame_347, $interval_347);

check $frame_347.width == 14, "[3,4,7] frame width mismatch";
check $lifted_ray_347.start == 6014, "[3,4,7] lifted ray mismatch";
check $lifted_interval_347.start == 6014, "[3,4,7] lifted interval start mismatch";
check $lifted_interval_347.end == 6060, "[3,4,7] lifted interval end mismatch";

report(
    "[3,4,7], k=1 residue lift",
    "modulus = {$mod6.value}",
    "frame width R = {$frame_347.width}",
    "multiple ray start = {$ray_347.start}",
    "lifted ray start = {$lifted_ray_347.start}",
    "lifted interval = [{$lifted_interval_347.start}, {$lifted_interval_347.end}]",
);

my $mod24 = modulus(24);
my $frame_34925 = residue-frame(
    $mod24,
    [0, 25, 170, 27, 52, 197, 198, 295, 80, 9, 106, 107,
     36, 133, 278, 279, 16, 89, 90, 43, 116, 117, 214, 359],
);
my $ray_34925 = multiple-ray($mod24, 24000);
my $interval_34925 = multiple-interval($mod24, 24000, 24720);
my $lifted_ray_34925 = lift($frame_34925, $ray_34925);
my $lifted_interval_34925 = lift($frame_34925, $interval_34925);

check $frame_34925.width == 359, "[3,4,9,25] frame width mismatch";
check $lifted_ray_34925.start == 24359, "[3,4,9,25] lifted ray mismatch";
check $lifted_interval_34925.start == 24359, "[3,4,9,25] lifted interval start mismatch";
check $lifted_interval_34925.end == 24720, "[3,4,9,25] lifted interval end mismatch";

report(
    "[3,4,9,25], k=2 residue lift",
    "modulus = {$mod24.value}",
    "frame width R = {$frame_34925.width}",
    "multiple ray start = {$ray_34925.start}",
    "lifted ray start = {$lifted_ray_34925.start}",
    "lifted interval = [{$lifted_interval_34925.start}, {$lifted_interval_34925.end}]",
);

my $unit_7 = unit-frame($mod6, 7, 1);
check $unit_7.order == 1, "base 7 modulo 6 order mismatch";
check $unit_7.terms.elems == 5, "base 7 modulo 6 term count mismatch";
check $unit_7.width == 19607, "base 7 modulo 6 unit-frame width mismatch";

report(
    "unit-base frame: base 7 modulo 6",
    "order = {$unit_7.order}",
    "term count = {$unit_7.terms.elems}",
    "frame width R = {$unit_7.width}",
);

my $mod5 = modulus(5);
my $unit_3 = unit-frame($mod5, 3, 1);
check $unit_3.order == 4, "base 3 modulo 5 order mismatch";
check $unit_3.terms.elems == 4, "base 3 modulo 5 term count mismatch";

report(
    "unit-base frame: base 3 modulo 5",
    "order = {$unit_3.order}",
    "term count = {$unit_3.terms.elems}",
    "frame width R = {$unit_3.width}",
);

say "Raku residue DSL certificate: PASS";
