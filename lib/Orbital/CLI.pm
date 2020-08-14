use Orbital::Transfer::Common::Setup;
package Orbital::CLI;
# ABSTRACT: Run Orbital

use Moo;
use CLI::Osprey;
use Hash::Merge;
use Module::Load;
use Module::Pluggable require => 1, search_path => ['Orbital::CLI::Container'];

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
			$pre //= '';
			load $merged->{$pre} if $pre;
			&{ $merged->{$pre} . '::subcommand'}($post => $merged->{$key});
		}
	}
}


method run(@) {
	...
}

__PACKAGE__->_load_commands;

1;
