# encoding: UTF-8
# frozen_string_literal: true

#--
# This file is part of Raketeer.
# Copyright (c) 2019 Jonathan Bradley Whited (@esotericpig)
# 
# Raketeer is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# Raketeer is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
# 
# You should have received a copy of the GNU Lesser General Public License
# along with Raketeer.  If not, see <https://www.gnu.org/licenses/>.
#++


lib = File.expand_path(File.join('..','lib'),__FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'raketeer/version'

Gem::Specification.new() do |spec|
  spec.name        = 'raketeer'
  spec.version     = Raketeer::VERSION
  spec.authors     = ['Jonathan Bradley Whited (@esotericpig)']
  spec.email       = ['bradley@esotericpig.com']
  spec.licenses    = ['LGPL-3.0-or-later']
  spec.homepage    = 'https://github.com/esotericpig/raketeer'
  spec.summary     = 'Extra Ruby Rake Tasks.'
  spec.description = 'Extra Ruby Rake Tasks for bumping the version, GitHub Packages, Nokogiri, IRB, running, etc.'
  
  spec.metadata = {
    'bug_tracker_uri' => 'https://github.com/esotericpig/raketeer/issues',
    'changelog_uri'   => 'https://github.com/esotericpig/raketeer/blob/master/CHANGELOG.md',
    'homepage_uri'    => 'https://github.com/esotericpig/raketeer',
    'source_code_uri' => 'https://github.com/esotericpig/raketeer'
  }
  
  spec.require_paths = ['lib']
  
  spec.files = Dir.glob(File.join("{#{spec.require_paths.join(',')}}",'**','*.{erb,rb}')) +
               Dir.glob(File.join('{test,yard}','**','*.{erb,rb}')) +
               %W( Gemfile #{spec.name}.gemspec Rakefile ) +
               %w( CHANGELOG.md LICENSE.txt README.md )
  
  spec.required_ruby_version = '>= 2.1.10'
  
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
  
  dv = Raketeer::DEP_VERSIONS
  
  spec.add_runtime_dependency 'rake' #,'~> 12.3'
  
  spec.add_development_dependency 'bundler','~> 1.17'
  spec.add_development_dependency 'irb'    ,dv['irb'] # For IRBTask
  spec.add_development_dependency 'yard'   ,'~> 0.9'  # For documentation
end
