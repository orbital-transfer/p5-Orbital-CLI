use Orbital::Transfer::Common::Setup;
package Orbital::CLI::Command::Dump;
# ABSTRACT: Dump configuration info

use Orbital::Transfer::Common::Setup;
use Moo;
use CLI::Osprey on_demand => 1;
use Module::Load qw(load);

sub run {
	my $config = do( path('~/.orbital/Orb') );
	my $data;
	for my $config ($config->configs->@*) {
		my $orbs = $config->orbs;
		for my $orb (@$orbs) {
			local @Orbital::Config::v0::REGISTRY = ();
			load $orb->{path};
			$orb->{loaded} = \@Orbital::Config::v0::REGISTRY;
		}
		push @$data, { config => $config, orbs => $orbs };
	}
	use DDP; p $data;
}

1;
