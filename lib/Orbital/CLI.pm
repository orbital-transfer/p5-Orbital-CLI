use Orbital::Transfer::Common::Setup;
package Orbital::CLI;
# ABSTRACT: Run Orbital

use Orbital::Transfer::Common::Setup;
use Moo;
use CLI::Osprey on_demand => 1;
use Hash::Merge;
use Module::Load;
use Module::Pluggable require => 1, search_path => ['Orbital::CLI::Container'];

our $COMMANDS;

classmethod _load_commands() {
	my $merger = Hash::Merge->new('LEFT_PRECEDENT');
	my $merged = {
		''        ,=> __PACKAGE__,
		'service'  => 'Orbital::CLI::Service',
		'account'  => 'Orbital::CLI::Command::Account',
	};

	for my $plugin ($class->plugins) {
		$merged = $merger->merge( $merged, $plugin->commands );
	}
	for my $key (keys %$merged) {
		next unless $key;
		{
			no strict 'refs'; ## no critic
			my ($pre, $post) = $key =~ m,(?:(.*)/)?([^/]+),;
			$COMMANDS->{$key} = 1;
			$pre //= '';
			load $merged->{$pre} if $pre;
			&{ $merged->{$pre} . '::subcommand'}($post => $merged->{$key});
		}
	}
}


method run(@) {
	$self->_load_commands;
	print join("\n", sort keys %$COMMANDS), "\n";
}

__PACKAGE__->_load_commands;

1;
