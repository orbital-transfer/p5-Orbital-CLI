use Oberth::Common::Setup;
package Oberth::CLI;
# ABSTRACT: Run Oberth

use Moo;
use CLI::Osprey;

subcommand 'github-issue-count' => 'Oberth::CLI::Command::NumberOfGitHubIssues';
subcommand account => 'Oberth::CLI::Command::Account';

method run(@) {
	...
}

1;
