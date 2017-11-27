use Oberth::Common::Setup;
package Oberth::CLI::Command::NumberOfGitHubIssues;
# ABSTRACT: A command to list the number of GitHub issues for a repository

use Oberth::Common::Types qw(AbsDir);

use Oberth::VCS::Git;
use Oberth::Service::GitHub;
use Oberth::Service::GitHub::Repo;
use Oberth::Service::Coveralls;
use Set::Scalar;
use Cwd;

use Moo;
use CLI::Osprey;

option repo_path => (
	is => 'ro',
	required => 1,
	format => 's',
	doc => 'Path to repository',
	isa => AbsDir,
	coerce => 1,
);

method run(@) {
	my $repo_path = $self->repo_path;
	say $repo_path;

	my $vcs = Oberth::VCS::Git->new( directory => $repo_path );
	my $remotes = $vcs->remotes;
	my $remote_uris = Set::Scalar->new(
		map { values %$_ } values %$remotes
	);
	my @github;
	for my $remote (@$remote_uris) {
		push @github, Oberth::Service::GitHub::Repo->new(
			uri => $remote,
		);
	}

	my %github_to_issues = map {
		( $_->github_https_web_uri => $_->number_of_open_issues ),
	} @github;
	use DDP; p %github_to_issues;
}

1;
