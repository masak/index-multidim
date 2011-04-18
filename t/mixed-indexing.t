use v6;

use Test;
use Index::Multidim;

{
    my @a =
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9],
    ;
    @a does Index::Multidim;
    is @a.M[0,1;;0], [1, 4].list, "two values first level, one value second";
    is @a.M[1;;1,2], [5, 6].list, "one value first level, two values second";
    is @a.M[0,2;;0,2], [[1, 3],[7, 9]].list, "multidimensional slice";
}

done;
