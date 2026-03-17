use strict;
use warnings;
use Test::More;

use Data::Hash::Diff::Smart qw(diff_text);

my $txt = diff_text({ a => 1 }, { a => 1 });

like($txt, qr/^\s*$/, 'empty diff produces empty text');

done_testing;

