use v6;

use Test;
use Index::Multidim;

{
    my @a =
        [
            ['a', 'b'],
            ['c', 'd'],
        ],
        [
            ['e', 'f'],
            ['g', 'h'],
        ],
    ;
    @a does Index::Multidim;
    is @a.M[0;;0;;0], 'a', "indexing three levels down works I";
    is @a.M[1;;1;;0], 'g', "indexing three levels down works II";
    is @a.M[0;;1;;1], 'd', "indexing three levels down works III";
}

done;
