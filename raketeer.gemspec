# encoding: UTF-8
# frozen_string_literal: true

require_relative 'lib/raketeer/version'

Gem::Specification.new do |spec|
  spec.name        = 'raketeer'
  spec.version     = Raketeer::VERSION
  spec.authors     = ['Bradley Whited']
  spec.email       = ['code@esotericpig.com']
  spec.licenses    = ['LGPL-3.0-or-later']
  spec.homepage    = 'https://github.com/esotericpig/raketeer'
  spec.summary     = 'Extra Ruby Rake Tasks.'
  spec.description = <<-DESC
Extra Ruby Rake Tasks for bumping the version, GitHub Packages, Nokogiri, IRB, running, etc.
  DESC

  spec.metadata = {
    'rubygems_mfa_required' => 'true',
    'homepage_uri'          => spec.homepage,
    'changelog_uri'         => 'https://github.com/esotericpig/raketeer/blob/main/CHANGELOG.md',
    'source_code_uri'       => 'https://github.com/esotericpig/raketeer',
    'bug_tracker_uri'       => 'https://github.com/esotericpig/raketeer/issues',
  }

  spec.required_ruby_version = '>= 2.1.10'
  spec.require_paths         = ['lib']
  spec.bindir                = 'bin'
  spec.executables           = []

  spec.files = [
    Dir.glob("{#{spec.require_paths.join(',')}}/**/*.{erb,rb}"),
    Dir.glob("#{spec.bindir}/*"),
    Dir.glob('{spec,test,yard}/**/*.{erb,rb}'),
    %W[Gemfile #{spec.name}.gemspec Rakefile],
    %w[CHANGELOG.md LICENSE.txt README.md],
  ].flatten

  # TODO: also add the below comment to the README & reword for user
  #
  # If it is a dependency specific to a task, then it should probably be added
  # as a development dependency (not a runtime dependency) so that a bunch of
  # non-essential dependencies (to the user) are not added.
  #
  # For example, if the user only uses the Nokogiri tasks, then they don't need
  # the IRB dependency.
  #
  # Therefore, it is up to the user to add the dependencies they need.
  # If the user uses the IRB task, then they will have to add 'irb' as a
  # development dependency in their own project's Gemspec.

  spec.add_dependency 'rake'
end
