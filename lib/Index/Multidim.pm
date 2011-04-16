use v6;

# The user does multidimensional indexing like this:
#
#       my @matrix =
#           [1, 2, 3],
#           [4, 5, 6],
#           [7, 8, 9],
#       ;
#       @matrix does Index::Multidim;
#       say @matrix.M[1;;2]; # row one, column 2: 6
#
# We accomplish this by putting all the behavior in the thing returned by
# the C<.M> method. We call this thing a "multiproxy", because it stands in
# for the real array until real arrays can do multidimensional indexing.

class Semi { ... }

class Lol {
    has @.values;

    sub listFromSemi(Semi $semi) {
        my @values =
            $semi.lhs ~~ Semi ?? listFromSemi($semi.lhs)
                              !! $semi.lhs;
        push @values, $semi.rhs;
        return @values;
    }

    method fromSemi(Semi $semi) { $.new(:values(listFromSemi($semi))) }
}

class Index::Multiproxy {
    has $!target;

    method postcircumfix:<[ ]>($_) {
        when Numeric { return $!target[$_] }
        when Semi {
            my $value = $!target;
            for Lol.fromSemi($_).values.list -> $index {
                $value = $value[$index];
            }
            return $value;
        }
    }
}

role Index::Multidim {
    method M { Index::Multiproxy.new(:target(self)) }
}

class Semi {
    has $.lhs;
    has $.rhs;
}

our sub infix:<;;>($lhs, $rhs) is export { Semi.new(:$lhs, :$rhs) }
