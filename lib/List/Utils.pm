module List::Utils;

sub sliding-window(@a, $n) is export(:DEFAULT) {
    my $a-list = @a.iterator.list;
    my @values;
    gather while defined(my $a = $a-list.shift) {
        @values.push($a);
        @values.shift if +@values > $n;
        take @values if +@values == $n;
    }
}

sub permute(@items) is export(:DEFAULT) {
    sub pattern_to_permutation(@pattern, @items1) {
        my @items = @items1;
        my @r;
        for @pattern {
            push @r, @items.splice($_, 1);
        }
        @r;
    }

    sub n_to_pat($n is copy, $length) {
        my @odometer;
        for 1 .. $length -> $i {
            unshift @odometer, $n % $i;
            $n div= $i;
        }
        return $n ?? () !! @odometer;
    }
    
    my $n = 0;
    gather loop {
        my @pattern = n_to_pat($n++, +@items);
        last unless ?@pattern;
        take pattern_to_permutation(@pattern, @items).item;
    }
}

sub take-while(@a, Mu $test) is export(:DEFAULT) {
    gather {
        for @a.list {
            when $test { take $_ }
            last;
        }
    }
}

sub transpose(@list is copy) is export(:DEFAULT) {
    gather {
        while @list {
            my @heads;
            if @list[0] !~~ Positional {
                @heads = @list.shift;
            }
            else {
                @heads = @list.map({$_.shift unless $_ ~~ []});
            }
            @list = @list.map({$_ unless $_ ~~ []});
            take [@heads];
        }
    }
}

sub lower-bound(@x, $key) is export(:DEFAULT) {
    my $first = 0;
    my $len = @x.elems;
    my $half;
    while ($len > 0 && $first < @x.elems)
    {
        $half = $len div 2;
        if (@x[$first + $half] < $key)
        {
            $first += $half + 1;
            $len -= $half + 1;
        }
        else
        {
            $len = $half;
        }
    }
    return $first;
}

sub upper-bound(@x, $key) is export(:DEFAULT) {
    my $first = 0;
    my $len = @x.elems;
    my $half;
    while ($len > 0 && $first < @x.elems)
    {
        $half = $len div 2;
        if (@x[$first + $half] <= $key)
        {
            $first += $half + 1;
            $len -= $half + 1;
        }
        else
        {
            $len = $half;
        }
    }
    return $first;
}

