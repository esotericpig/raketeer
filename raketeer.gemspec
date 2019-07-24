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


lib = File.expand_path('../lib',__FILE__)
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
  spec.description = "#{spec.summary} Tasks for IRB, Nokogiri, etc."
  
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
  
  spec.add_runtime_dependency 'rake' #,'~> 12.3'
  
  spec.add_development_dependency 'bundler','~> 1.17'
  spec.add_development_dependency 'yard'   ,'~> 0.9'  # For doc
end
