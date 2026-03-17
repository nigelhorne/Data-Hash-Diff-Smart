package Data::Hash::Diff::Smart;

use strict;
use warnings;

use Exporter 'import';
use Data::Hash::Diff::Smart::Engine;
use Data::Hash::Diff::Smart::Renderer::Text;

our @EXPORT_OK = qw(
    diff
    diff_text
);

our $VERSION = '0.01';

sub diff {
    my ($old, $new, %opts) = @_;
    return Data::Hash::Diff::Smart::Engine::diff($old, $new, %opts);
}

sub diff_text {
    my ($old, $new, %opts) = @_;
    my $changes = diff($old, $new, %opts);
    return Data::Hash::Diff::Smart::Renderer::Text::render($changes);
}

1;

