# encoding: UTF-8
# frozen_string_literal: true

require 'bundler/gem_tasks'

require 'raketeer'
require 'rake/clean'

task default: []

CLEAN.exclude('.git/','.github/','.idea/','stock/')
CLOBBER.include('doc/')

namespace :rt do
  require 'raketeer/all'
end

namespace :todo do
  # TODO: make this into a task class
  # TODO: do 'gem:files'? and also 'gem:info' for all other methods?
  desc 'Output dat gemspec bootyliciousness'
  task :gem do |_task,_args|
    # TODO: if this doesn't work, read *.gemspec somehow? probably not...
    gem = Gem::Specification.find_by_name('raketeer')
    puts gem.files
    # puts gem.methods.sort - Object.methods
  end
end
