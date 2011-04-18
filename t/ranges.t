use v6;

use Test;
use Index::Multidim;

{
    my @a = 0, 1, 2, 3, 4, 5, 6, 7;
    @a does Index::Multidim;
    is @a.M[3..5], [3, 4, 5].list, "indexing one dimension with a range";
    is @a.M[0..2, 4..6],
        [0, 1, 2, 4, 5, 6].list,
        "indexing one dimension with two ranges";
}

{
    my @a =
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9],
    ;
    @a does Index::Multidim;
    is @a.M[0..1;;0], 1, "range and number";
    is @a.M[1;;1..2], 6, "number and range";
    is @a.M[0..1;;1..2], 8, "two ranges";
}

done;
