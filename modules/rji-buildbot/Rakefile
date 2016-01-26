require 'rubygems'
require 'rake'
require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'

PuppetLint.configuration.ignore_paths = ["spec/**/*.pp", "vendor/**/*.pp"]
PuppetLint.configuration.send('disable_autoloader_layout')
PuppetLint.configuration.send('disable_80chars')
PuppetLint.configuration.send('disable_class_inherits_from_params_class')
PuppetLint.configuration.send('disable_documentation')
PuppetLint.configuration.send('disable_only_variable_string')
PuppetLint.configuration.send('disable_single_quote_string_with_variables')

ENV['SPEC_OPTS'] = "-fd -c --deprecation-out /dev/null"
task :default => [ :lint, :spec ]
