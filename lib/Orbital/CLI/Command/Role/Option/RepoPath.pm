use Orbital::Transfer::Common::Setup;
package Orbital::CLI::Command::Role::Option::RepoPath;
# ABSTRACT: A role for commands that take a repo path

use Orbital::Transfer::Common::Types qw(AbsDir);
use Path::Tiny;

use Moo::Role;
use CLI::Osprey;

option repo_path => (
	is => 'ro',
	required => 0,
	format => 's',
	doc => 'Path to repository',
	isa => AbsDir,
	coerce => 1,
	default => sub { path('.') },
);

1;
