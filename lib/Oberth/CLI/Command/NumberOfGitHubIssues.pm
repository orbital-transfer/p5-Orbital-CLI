use Oberth::Common::Setup;
package Oberth::CLI::Command::NumberOfGitHubIssues;
# ABSTRACT: A command to list the number of GitHub issues for a repository

use Oberth::Service::Coveralls;

use Moo;
use CLI::Osprey;

method run(@) {
	my $github = $self->github_repos;
	my %github_to_issues = map {
		( $_->github_https_web_uri => $_->number_of_open_issues ),
	} @$github;
	use DDP; p %github_to_issues;
}

with qw(Oberth::CLI::Command::Role::GitHubRepos);

1;
