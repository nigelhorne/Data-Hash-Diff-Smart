package Data::Hash::Diff::Smart::Renderer::Text;

use strict;
use warnings;

sub render {
    my ($changes) = @_;

    return join "\n",
        map {
            my $op = $_->{op};
            my $path = $_->{path};
            if ($op eq 'change') {
                "~ $path\n- $_->{from}\n+ $_->{to}\n";
            }
            elsif ($op eq 'add') {
                "+ $path\n+ $_->{value}\n";
            }
            elsif ($op eq 'remove') {
                "- $path\n";
            }
            else {
                "# unknown op: $op";
            }
        } @$changes;
}

1;

