package Bash::Completion::Plugins::Orbital::CLI;
# ABSTRACT: Bash::Completion plugin for Orbital::CLI

use strict;
use warnings;
use parent 'Bash::Completion::Plugins::CLI::Osprey';
use Path::Tiny;
use Types::Path::Tiny qw(Path Dir AbsDir File AbsFile);

use Bash::Completion::Utils qw(command_in_path prefix_match);

sub complete_option {
	my ($self, $r, $subcommand_class, $option ) = @_;

	my @names = ();
	my $attribute = $subcommand_class->meta->find_attribute_by_name($option);
	if( exists $attribute->{isa} &&
		( $attribute->{isa}->is_subtype_of(Path) )
	) {
		require File::Glob;
		@names = File::Glob::bsd_glob($r->word . '*');

		@names = grep { -d } @names
			if $attribute->{isa} == Dir || $attribute->{isa} == AbsDir;

		@names = grep { -f } @names
			if $attribute->{isa} == File || $attribute->{isa} == AbsFile;

		if( $r->word =~ /^~/ ) {
			my $tilde_expansion = File::Glob::bsd_glob('~');
			@names = map {
				s|^\Q$tilde_expansion\E|~|r;
			} @names;
		}
		push @names, $names[0] . '/' if @names == 1;
	}

	$r->candidates(prefix_match($r->word, @names));
}

sub should_activate {
	return [ grep { command_in_path($_) } qw(orbital-cli) ];
}

sub command_class { 'Orbital::CLI' }

1;
