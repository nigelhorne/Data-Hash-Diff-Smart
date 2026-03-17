package Data::Hash::Diff::Smart;

use strict;
use warnings;

use Exporter 'import';
use Data::Hash::Diff::Smart::Engine;
use Data::Hash::Diff::Smart::Renderer::Text;
use Data::Hash::Diff::Smart::Renderer::JSON;
use Data::Hash::Diff::Smart::Renderer::YAML;

our @EXPORT_OK = qw(
    diff
    diff_text
    diff_json
    diff_yaml
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

sub diff_json {
    my ($old, $new, %opts) = @_;
    my $changes = diff($old, $new, %opts);
    return Data::Hash::Diff::Smart::Renderer::JSON::render($changes);
}

sub diff_yaml {
    my ($old, $new, %opts) = @_;
    my $changes = diff($old, $new, %opts);
    return Data::Hash::Diff::Smart::Renderer::YAML::render($changes);
}

1;
