use Oberth::Manoeuvre::Common::Setup;
package Oberth::CLI::Command::Role::GitHubRepos;
# ABSTRACT: Gets GitHub repos from repo path

use Moo::Role;

use Set::Scalar;
use Oberth::Block::VCS::Git;
use Oberth::Block::Service::GitHub;
use Oberth::Block::Service::GitHub::Repo;
use List::AllUtils qw(first);

has github_repos => ( is => 'lazy' );

has github_repo_origin => ( is => 'lazy' );

method _build_github_repo_origin() {
	my $repo_path = $self->repo_path;

	my $vcs = Oberth::Block::VCS::Git->new( directory => $repo_path );
	my $remotes = $vcs->remotes;
	my $origin = first { $_->name eq 'origin' } @$remotes;

	return Oberth::Block::Service::GitHub::Repo->new(
		uri => $origin->fetch,
	);
}

method _build_github_repos() {
	my $repo_path = $self->repo_path;

	my $vcs = Oberth::Block::VCS::Git->new( directory => $repo_path );
	my $remotes = $vcs->remotes;
	my $remote_uris = Set::Scalar->new(
		map { $_->fetch } @$remotes
	);

	my @github;
	for my $remote (@$remote_uris) {
		push @github, Oberth::Block::Service::GitHub::Repo->new(
			uri => $remote,
		);
	}

	return \@github;
}

with qw(Oberth::CLI::Command::Role::Option::RepoPath);

1;
