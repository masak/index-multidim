use v6;

use Test;
use Index::Multidim;

class O { method postcircumfix:<[ ]>(*@a) { @a } }

sub objects_to_strings(@tokens) {
    [for @tokens {
        when OpType { .WHAT.perl.subst(/.* '::'/, '') };
        default { $_ }
    }]
}

my $o = O.new;

my @tests =
    $o[],         [],
    $o[1, 2],     [1, 'Comma', 2],
    $o[1, 2, 3],  [1, 'Comma', 2, 'Comma', 3],
    $o[1..2],     [1, 'Range', 2],
;

for @tests -> @input, @expected_output {
    is_deeply objects_to_strings(
                Index::Multidim::Tokenizer::tokenize(@input)
              ),
              @expected_output,
              @input.perl;
}

done;
