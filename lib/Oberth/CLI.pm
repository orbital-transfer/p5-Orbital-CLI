use Oberth::Manoeuvre::Common::Setup;
package Oberth::CLI;
# ABSTRACT: Run Oberth

use Moo;
use CLI::Osprey;
use Hash::Merge;
use Module::Load;
use Module::Pluggable require => 1, search_path => ['Oberth::CLI::Container'];

classmethod _load_commands() {
	my $merger = Hash::Merge->new('LEFT_PRECEDENT');
	my $merged = {
		''        ,=> __PACKAGE__,
		'service'  => 'Oberth::CLI::Service',
		'account'  => 'Oberth::CLI::Command::Account',
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
