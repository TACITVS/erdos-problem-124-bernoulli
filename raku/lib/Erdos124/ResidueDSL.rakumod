unit module Erdos124::ResidueDSL;

class Modulus is export {
    has Int $.value;

    submethod BUILD(:$value!) {
        die "modulus must be positive, got $value" unless $value > 0;
        $!value = $value;
    }
}

class CongruenceTarget {
    has Int $.right;
    has Modulus $.modulus;
}

sub modulo(Int $right, Modulus $modulus --> CongruenceTarget) is export {
    CongruenceTarget.new(:$right, :$modulus)
}

sub infix:<≡ₘ>(Int $left, CongruenceTarget $target --> Bool) is export {
    ($left - $target.right) %% $target.modulus.value
}

class ResidueFrame is export {
    has Modulus $.modulus;
    has Int @.representatives;

    submethod BUILD(:$modulus!, :@representatives!) {
        die "expected {$modulus.value} representatives, got {@representatives.elems}"
            unless @representatives.elems == $modulus.value;
        die "residue representatives must be nonnegative"
            if @representatives.grep(* < 0);

        for @representatives.kv -> $residue, $value {
            die "representative $value has wrong residue $residue modulo {$modulus.value}"
                unless $value ≡ₘ modulo($residue, $modulus);
        }

        $!modulus = $modulus;
        @!representatives = @representatives;
    }

    method width(--> Int) {
        @!representatives.max // 0
    }
}

class MultipleRay is export {
    has Modulus $.modulus;
    has Int $.start;

    submethod BUILD(:$modulus!, :$start!) {
        die "multiple ray start must be nonnegative, got $start" unless $start >= 0;
        die "ray start $start is not divisible by {$modulus.value}"
            unless is-multiple($start, $modulus);
        $!modulus = $modulus;
        $!start = $start;
    }
}

class MultipleInterval is export {
    has Modulus $.modulus;
    has Int $.start;
    has Int $.end;

    submethod BUILD(:$modulus!, :$start!, :$end!) {
        die "multiple interval endpoints must be nonnegative: ($start, $end)"
            unless $start >= 0 && $end >= 0;
        die "empty multiple interval: ($start, $end)" unless $start <= $end;
        die "interval start $start is not divisible by {$modulus.value}"
            unless is-multiple($start, $modulus);
        die "interval end $end is not divisible by {$modulus.value}"
            unless is-multiple($end, $modulus);

        $!modulus = $modulus;
        $!start = $start;
        $!end = $end;
    }
}

class IntegerRay is export {
    has Int $.start;
}

class IntegerInterval is export {
    has Int $.start;
    has Int $.end;

    submethod BUILD(:$start!, :$end!) {
        die "empty integer interval: ($start, $end)" unless $start <= $end;
        $!start = $start;
        $!end = $end;
    }
}

class UnitFrame is export {
    has Modulus $.modulus;
    has Int $.base;
    has Int $.exponent-start;
    has Int $.order;
    has Int @.terms;
    has ResidueFrame $.frame;

    method width(--> Int) {
        $!frame.width
    }

    method representatives(--> List) {
        $!frame.representatives.List
    }
}

sub modulus(Int $value --> Modulus) is export {
    Modulus.new(:$value)
}

sub is-multiple(Int $value, Modulus $modulus --> Bool) is export {
    $value %% $modulus.value
}

sub residue-frame(Modulus $modulus, @representatives --> ResidueFrame) is export {
    ResidueFrame.new(:$modulus, :@representatives)
}

sub multiple-ray(Modulus $modulus, Int $start --> MultipleRay) is export {
    MultipleRay.new(:$modulus, :$start)
}

sub multiple-interval(Modulus $modulus, Int $start, Int $end --> MultipleInterval) is export {
    MultipleInterval.new(:$modulus, :$start, :$end)
}

multi sub lift(ResidueFrame $frame, MultipleRay $ray --> IntegerRay) is export {
    same-modulus($frame.modulus, $ray.modulus);
    IntegerRay.new(start => $ray.start + $frame.width)
}

multi sub lift(ResidueFrame $frame, MultipleInterval $interval --> IntegerInterval) is export {
    same-modulus($frame.modulus, $interval.modulus);
    IntegerInterval.new(start => $interval.start + $frame.width, end => $interval.end)
}

sub multiplicative-order(Modulus $modulus, Int $base --> Int) is export {
    die "base must be positive, got $base" unless $base > 0;
    die "base $base is not a unit modulo {$modulus.value}"
        unless gcd-int($base, $modulus.value) == 1;
    return 1 if $modulus.value == 1;

    for 1 .. $modulus.value -> $candidate {
        return $candidate if pow-mod($base, $candidate, $modulus.value) == 1;
    }
    die "could not find multiplicative order modulo {$modulus.value}";
}

sub unit-frame(Modulus $modulus, Int $base, Int $exponent-start --> UnitFrame) is export {
    die "exponent start must be nonnegative, got $exponent-start"
        unless $exponent-start >= 0;

    my $order = multiplicative-order($modulus, $base);
    my @terms = (0 ..^ ($modulus.value - 1)).map(
        -> $step { int-pow($base, $exponent-start + $step * $order) }
    );
    my @prefix = 0;
    for @terms -> $term {
        @prefix.push(@prefix[*-1] + $term);
    }

    my $unit = pow-mod($base, $exponent-start, $modulus.value);
    my @representatives = (0 ..^ $modulus.value).map(
        -> $residue {
            my $coefficient = residue-coefficient($modulus, $unit, $residue);
            @prefix[$coefficient]
        }
    );
    my $frame = residue-frame($modulus, @representatives);

    UnitFrame.new(
        :$modulus,
        :$base,
        :exponent-start($exponent-start),
        :$order,
        :@terms,
        :$frame,
    )
}

sub same-modulus(Modulus $left, Modulus $right) {
    die "modulus mismatch: {$left.value} versus {$right.value}"
        unless $left.value == $right.value;
}

sub residue-coefficient(Modulus $modulus, Int $unit, Int $residue --> Int) {
    for 0 ..^ $modulus.value -> $coefficient {
        return $coefficient
            if ($coefficient * $unit - $residue) %% $modulus.value;
    }
    die "could not solve residue $residue using unit $unit modulo {$modulus.value}";
}

sub gcd-int(Int $a is copy, Int $b is copy --> Int) {
    $a = $a.abs;
    $b = $b.abs;
    while $b != 0 {
        ($a, $b) = ($b, $a % $b);
    }
    $a
}

sub int-pow(Int $base, Int $power --> Int) {
    die "negative integer power $power" if $power < 0;
    my Int $acc = 1;
    my Int $current = $base;
    my Int $remaining = $power;

    while $remaining > 0 {
        if $remaining % 2 == 1 {
            $acc *= $current;
        }
        $remaining div= 2;
        $current *= $current if $remaining > 0;
    }
    $acc
}

sub pow-mod(Int $base, Int $power, Int $modulus --> Int) {
    return 0 if $modulus == 1;
    die "negative modular power $power" if $power < 0;

    my Int $acc = 1 % $modulus;
    my Int $current = $base % $modulus;
    my Int $remaining = $power;

    while $remaining > 0 {
        if $remaining % 2 == 1 {
            $acc = ($acc * $current) % $modulus;
        }
        $remaining div= 2;
        $current = ($current * $current) % $modulus if $remaining > 0;
    }
    $acc
}
