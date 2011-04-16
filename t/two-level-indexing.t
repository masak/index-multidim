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
    is @a.M[0;;0], 1, "indexing two levels down works I";
    is @a.M[1;;2], 6, "indexing two levels down works II";
    is @a.M[2;;1], 8, "indexing two levels down works III";
}

done;
