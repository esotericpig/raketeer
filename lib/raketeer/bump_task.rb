#!/usr/bin/env ruby
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


require 'date'
require 'rake'

require 'rake/tasklib'

require 'raketeer/bump_ver'
require 'raketeer/files_bumper'
require 'raketeer/sem_ver'
require 'raketeer/util'

module Raketeer
  ###
  # @author Jonathan Bradley Whited (@esotericpig)
  # @since  0.2.4
  ###
  class BumpTask < Rake::TaskLib
    attr_accessor :bump_bundle
    attr_accessor :bump_files # Looks for a version number
    attr_accessor :bundle_cmd
    attr_accessor :changelogs # Looks for 'Unreleased' & a header
    attr_accessor :description
    attr_accessor :dry_run
    attr_accessor :git_msg
    attr_accessor :name
    attr_accessor :ruby_files # Looks for {ruby_var}
    attr_accessor :ruby_var
    
    alias_method :dry_run?,:dry_run
    
    def initialize(name=:bump)
      super()
      
      @bump_bundle = false
      @bump_files = Rake::FileList[]
      @bundle_cmd = 'bundle'
      @changelogs = Rake::FileList['CHANGELOG.md']
      @dry_run = false
      @git_msg = %q(git commit -m 'Bump version to v%{version}')
      @name = name
      @ruby_files = Rake::FileList[File.join('lib','**','version.rb')]
      @ruby_var = 'VERSION'
      
      yield self if block_given?()
      define()
    end
    
    def define()
      desc 'Show/Set/Bump the version'
      task @name,[:version] do |task,args|
        check_env()
        bump_all(BumpVer.new(
          version: args.version,
          major: ENV['major'],
          minor: ENV['minor'],
          patch: ENV['patch'],
          prerelease: ENV['pre'],
          build_meta: ENV['build']
        ))
      end
      
      namespace @name do
        desc 'Bump/Set the major version'
        task :major,[:major] do |task,args|
          bump_ver = BumpVer.new(major: args.major)
          
          # You can't erase the major version (required)
          bump_ver.major = '+1' if bump_ver.major.nil?() || bump_ver.major.empty?()
          
          check_env()
          bump_all(bump_ver)
        end
        
        desc 'Bump/Set the minor version'
        task :minor,[:minor] do |task,args|
          bump_ver = BumpVer.new(minor: args.minor)
          bump_ver.minor = '+1' if bump_ver.minor.nil?()
          
          check_env()
          bump_all(bump_ver)
        end
        
        desc 'Bump/Set the patch version'
        task :patch,[:patch] do |task,args|
          bump_ver = BumpVer.new(patch: args.patch)
          bump_ver.patch = '+1' if bump_ver.patch.nil?()
          
          check_env()
          bump_all(bump_ver)
        end
        
        desc 'Set/Erase the pre-release version'
        task :pre,[:pre] do |task,args|
          bump_ver = BumpVer.new(prerelease: args.pre)
          bump_ver.prerelease = '' if bump_ver.prerelease.nil?()
          
          check_env()
          bump_all(bump_ver)
        end
        
        desc 'Set/Erase the build metadata'
        task :build,[:build] do |task,args|
          bump_ver = BumpVer.new(build_meta: args.build)
          bump_ver.build_meta = '' if bump_ver.build_meta.nil?()
          
          check_env()
          bump_all(bump_ver)
        end
        
        desc 'Bump the bundle version'
        task :bundle do
          check_env()
          bump_bundle_file()
        end
        
        desc "Show the help/usage for #{name} tasks"
        task :help do
          print_help()
        end
      end
    end
    
    def bump_all(bump_ver)
      sem_ver = []
      
      # Order matters for outputting the most accurate version
      sem_ver << bump_ruby_files(bump_ver)
      sem_ver << bump_bump_files(bump_ver)
      sem_ver << bump_changelogs(bump_ver)
      
      sem_ver.compact!()
      
      if @bump_bundle && !bump_ver.empty?() && !sem_ver.empty?()
        bump_bundle_file()
      end
      
      # Always output it, in case the user just wants to see what the git message
      # should be without making changes.
      if !sem_ver.empty?()
        puts '[Git]:'
        puts '= ' + (@git_msg % {version: sem_ver[0].to_s()})
      end
    end
    
    def bump_bump_files(bump_ver)
      bumper = FilesBumper.new(@bump_files,bump_ver,@dry_run)
      
      bumper.bump_files() do
        next if bumper.changes > 0 || bumper.line !~ SemVer::REGEX
        
        break if bumper.bump_line(bumper.line) && bumper.bump_ver_empty?()
      end
      
      return bumper.version
    end
    
    def bump_bundle_file()
      sh_cmd = [@bundle_cmd,'list']
      
      puts "[#{sh_cmd.join(' ')}]:"
      
      if @dry_run
        puts '= Nothing written (dry run)'
        
        return
      end
      
      sh(*sh_cmd,{:verbose => false})
    end
    
    # https://keepachangelog.com/en/1.0.0/
    def bump_changelogs(bump_ver)
      bumper = FilesBumper.new(@changelogs,bump_ver,@dry_run) do
        @header_bumped = false
        @unreleased_bumped = false
      end
      header_regex = /\A\s*##\s*\[[^\]]+\]/
      unreleased_regex = /\A.*Unreleased.*http/
      
      bumper.bump_files() do
        if @header_bumped && @unreleased_bumped
          if bumper.bump_ver_empty?()
            break
          else
            next
          end
        end
        
        if bumper.line =~ unreleased_regex
          next if @unreleased_bumped
          
          unreleased = bumper.line.split(unreleased_regex,2)
          
          next if unreleased.length != 2
          next if (unreleased = unreleased[1].strip()).empty?()
          
          unreleased = unreleased.split('...',2)[0].strip()
          
          next if unreleased.empty?()
          
          @unreleased_bumped = true if bumper.bump_line(unreleased)
        elsif bumper.line =~ header_regex
          next if @header_bumped
          
          header = bumper.line.split(/[\[\]]+/,3)
          
          next if header.length < 2
          next if (header = header[1].strip()).empty?()
          
          orig_line = bumper.line.dup()
          
          if bumper.bump_line(header,add_change: false)
            @header_bumped = true
            
            if !bumper.bump_ver_empty?()
              bumper.line.sub!(/\d+\s*\-\s*\d+\s*\-\s*\d+(.*)\z/m,"#{Date.today().strftime('%F')}\\1")
              bumper.add_change(bumper.line,push: true)
              bumper.line << "\n"
              
              bumper.line = orig_line
            end
          else
            bumper.line = orig_line
          end
        end
      end
      
      return bumper.version
    end
    
    def bump_ruby_files(bump_ver)
      bumper = FilesBumper.new(@ruby_files,bump_ver,@dry_run)
      var_regex = /\A\s*#{Regexp.quote(@ruby_var)}\s*=\D*/
      
      bumper.bump_files() do
        next if bumper.changes > 0 || bumper.line !~ var_regex
        
        ver_line = bumper.line.split(var_regex,2)
        
        next if ver_line.length != 2
        next if (ver_line = ver_line[1].strip()).empty?()
        
        break if bumper.bump_line(ver_line) && bumper.bump_ver_empty?()
      end
      
      return bumper.version
    end
    
    def check_env()
      env_dryrun = ENV['dryrun']
      
      if !env_dryrun.nil?() && !(env_dryrun = env_dryrun.to_s().strip()).empty?()
        @dry_run = Util.to_bool(env_dryrun)
      end
    end
    
    def print_help()
      puts <<-EOH
rake #{@name}  # Print the current version

# You can run a dry run for any task (will not write to files)
rake #{@name} dryrun=true

rake #{@name}[1.2.3-alpha.4-beta.5]       # Set the version manually
rake #{@name} major=1 minor=2 patch=3     # Set the version numbers
rake #{@name} pre=alpha.4 build=beta.5    # Set the version extensions
rake #{@name} major=+1 minor=+1 patch=+1  # Bump the version numbers by 1
rake #{@name} major=+2 minor=+3 patch=+4  # Bump the version numbers by X

rake #{@name}:major          # Bump the major version by 1
rake #{@name}:major[1]       # Set the major version
rake #{@name}:major[+2]      # Bump the major version by 2
rake #{@name}:minor          # Bump the minor version by 1
rake #{@name}:minor[2]       # Set the minor version
rake #{@name}:minor[+3]      # Bump the minor version by 3
rake #{@name}:patch          # Bump the patch version by 1
rake #{@name}:patch[3]       # Set the patch version
rake #{@name}:patch[+4]      # Bump the patch version by 4
rake #{@name}:pre            # Erase the pre-release version
rake #{@name}:pre[alpha.4]   # Set the pre-release version
rake #{@name}:build          # Erase the build metadata
rake #{@name}:build[beta.5]  # Set the build metadata
      EOH
    end
  end
end
