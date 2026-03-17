use strict;
use warnings;
use Test::More;

use Data::Hash::Diff::Smart qw(diff);

my $old = { a => 1 };
my $new = { a => 1 };

my $changes = diff($old, $new);

is_deeply($changes, [], 'no changes for identical structures');

done_testing;

