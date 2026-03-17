package Data::Hash::Diff::Smart;

use strict;
use warnings;

use Exporter 'import';
use Data::Hash::Diff::Smart::Engine ();

our @EXPORT_OK = qw(
	diff
	diff_text
	diff_json
	diff_yaml
	diff_test2
);

our $VERSION = '0.01';

# Core diff
sub diff {
	my ($old, $new, %opts) = @_;
	return Data::Hash::Diff::Smart::Engine::diff($old, $new, %opts);
}

# Text renderer (lazy-loaded)
sub diff_text {
	my ($old, $new, %opts) = @_;
	require Data::Hash::Diff::Smart::Renderer::Text;
	my $changes = diff($old, $new, %opts);
	return Data::Hash::Diff::Smart::Renderer::Text::render($changes);
}

# JSON renderer (lazy-loaded)
sub diff_json {
	my ($old, $new, %opts) = @_;
	require Data::Hash::Diff::Smart::Renderer::JSON;
	my $changes = diff($old, $new, %opts);
	return Data::Hash::Diff::Smart::Renderer::JSON::render($changes);
}

# YAML renderer (lazy-loaded)
sub diff_yaml {
	my ($old, $new, %opts) = @_;
	require Data::Hash::Diff::Smart::Renderer::YAML;
	my $changes = diff($old, $new, %opts);
	return Data::Hash::Diff::Smart::Renderer::YAML::render($changes);
}

sub diff_test2 {
	my ($old, $new, %opts) = @_;
	require Data::Hash::Diff::Smart::Renderer::Test2;
	my $changes = diff($old, $new, %opts);
	return Data::Hash::Diff::Smart::Renderer::Test2::render($changes);
}

1;
