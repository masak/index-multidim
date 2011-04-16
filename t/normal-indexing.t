use v6;

use Test;
use Index::Multidim;

{
    my @a does Index::Multidim;
    @a = 1, 2, 3;
    ok @a ~~ Index::Multidim, "'does' first, assignment afterwards";
}

{
    my @a = 4, 5, 6;
    @a does Index::Multidim;
    ok @a ~~ Index::Multidim, "assignment first, 'does' afterwards";
}

{
    my @a = 7, 8, 9;
    is @a[1], 8, "just making sure normal indexing still works";
}

{
    (my @a = 10, 11, 12) does Index::Multidim;
    is @a.M[1], 11, "...and that .M indexing works the same";
} 

done;
