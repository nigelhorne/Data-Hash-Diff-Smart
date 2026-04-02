package Data::Hash::Diff::Smart::Renderer::YAML;

use strict;
use warnings;

use YAML::XS ();

sub render {
	my $changes = $_[0];

	# YAML::XS::Dump returns a trailing newline — that’s fine
	return YAML::XS::Dump($changes);
}

1;
