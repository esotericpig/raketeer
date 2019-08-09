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


require 'bundler/gem_tasks'

require 'raketeer'

require 'rake/clean'

task default: []

CLEAN.exclude('.git/','stock/')
CLOBBER.include('doc/')

namespace :rt do
  require 'raketeer/all'
end

namespace :todo do
  # TODO: make this into a task class
  # TODO: do 'gem:files'? and also 'gem:info' for all other methods?
  desc 'Output dat gemspec bootyliciousness'
  task :gem do |task,args|
    # TODO: if this doesn't work, read *.gemspec somehow? probably not...
    gem = Gem::Specification.find_by_name('raketeer')
    puts gem.files
    #puts gem.methods.sort - Object.methods
  end
end
