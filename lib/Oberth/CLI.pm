use Oberth::Manoeuvre::Common::Setup;
package Oberth::CLI;
# ABSTRACT: Run Oberth

use Moo;
use CLI::Osprey;

subcommand 'github-issue-count' => 'Oberth::CLI::Command::NumberOfGitHubIssues';
subcommand account => 'Oberth::CLI::Command::Account';

subcommand 'travis-ci' => 'Oberth::CLI::Command::TravisCI';
subcommand 'coveralls' => 'Oberth::CLI::Command::Coveralls';
subcommand 'appveyor' => 'Oberth::CLI::Command::AppVeyor';

method run(@) {
	...
}

1;
