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
#
# On the way, we use a number of other helper classes. The C<Semi> simply
# captures the fact that there's a C<;;> in the multidimensional slice. This
# should really be a list-associative operator, but Rakudo doesn't support
# declaring those yet, so instead we jiggle around the resulting expression
# tree until it reflects what a list-associative operator I<should> have
# given us. This result is returned as a C<Lol>, a "list of lists". The
# C<Lol> is what is then used for the multidimensional indexing.

class OpType;
# RAKUDO: This could better be expressed as 'constant $.thightness = ...'
class OpType::Semicolon is OpType { method tightness { 1 } };
class OpType::Comma     is OpType { method tightness { 2 } };
class OpType::Range     is OpType { method tightness { 3 } };

module Index::Multidim::Tokenizer {
    our sub tokenize(@input) {
        my @tokens;
        for @input {
            push @tokens, $_, OpType::Comma;
        }
        pop @tokens; # because we don't want the last comma op
        return @tokens;
    }
}

class Semi { ... }

class Lol {
    has @!dimensions;

    method fromParcel(Parcel $parcel) {
        # Problem: infix:<;;> has the wrong precedence. It binds tighter
        # than both infix:<,> and infix:<..>, causing the wrong things to
        # be associated with each other. All the terms are still there in
        # the expression tree, but they're all jumbled around.
        #
        # Solution: we re-tokenize the expression tree, and re-parse it with
        # a small optable parser that knows the right precedence levels.

        return Lol.new();
    }

    method list {
        @!dimensions.list
    }
}

class Index::Multiproxy {
    has $!target;

    method postcircumfix:<[ ]>($_) {
        when Numeric | Range { return $!target[$_] }
        when Semi {
            return @.index-with(Lol.fromParcel( ($_,) ));
        }
        when Parcel {
            return @.index-with(Lol.fromParcel( $_ ));
        }
        default { die "Don't know how to index with a $_.WHAT.perl()" }
    }

    method index-with(Lol $lol) {
        my @values = $!target;
        for $lol.list -> @dimension {
            @values = map { .[@dimension] }, @values;
        }
        return @values;
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
