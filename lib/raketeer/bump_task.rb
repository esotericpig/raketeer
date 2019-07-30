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


require 'rake'

require 'rake/tasklib'

# TODO: bump_bundle boolean instance var? and bump:bundle task?
# TODO: set dryrun with ENV var? ENV['dryrun']?
# TODO: bump:init task to create version.rb file, etc. version param/ENVs
# FIXME: rename bump:meta to bump:build?

module Raketeer
  ###
  # @author Jonathan Bradley Whited (@esotericpig)
  # @since  0.2.4
  ###
  class BumpTask < Rake::TaskLib
    attr_accessor :bump_files # Looks for a version number
    attr_accessor :changelogs # Looks for 'Unreleased' & a header
    attr_accessor :description
    attr_accessor :dry_run
    attr_accessor :git_msg
    attr_accessor :name
    attr_accessor :ruby_files # Looks for a var
    attr_accessor :ruby_var
    
    def initialize(name=:bump)
      super()
      
      @bump_files = Rake::FileList[]
      @changelogs = Rake::FileList['CHANGELOG.md']
      @dry_run = true
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
        bump_all(BumpVer.new(
          version: args.version,
          major: ENV['major'],
          minor: ENV['minor'],
          patch: ENV['patch'],
          prerelease: ENV['pre'],
          metadata: ENV['meta']
        ))
      end
      
      namespace @name do
        desc 'Bump/Set the major version'
        task :major,[:major] do |task,args|
          bump_ver = BumpVer.new(major: args.major)
          bump_ver.major = '+1' if bump_ver.major.nil?() || bump_ver.major.empty?()
          
          bump_all(bump_ver)
        end
        
        desc 'Bump/Set the minor version'
        task :minor,[:minor] do |task,args|
          bump_ver = BumpVer.new(minor: args.minor)
          bump_ver.minor = '+1' if bump_ver.minor.nil?()
          
          bump_all(bump_ver)
        end
        
        desc 'Bump/Set the patch version'
        task :patch,[:patch] do |task,args|
          bump_ver = BumpVer.new(patch: args.patch)
          bump_ver.patch = '+1' if bump_ver.patch.nil?()
          
          bump_all(bump_ver)
        end
        
        desc 'Bump/Set the pre-release version'
        task :pre,[:pre] do |task,args|
          bump_ver = BumpVer.new(prerelease: args.pre)
          bump_ver.prerelease = '' if bump_ver.prerelease.nil?()
          
          bump_all(bump_ver)
        end
        
        desc 'Bump/Set the build metadata'
        task :meta,[:meta] do |task,args|
          bump_ver = BumpVer.new(metadata: args.meta)
          bump_ver.metadata = '' if bump_ver.metadata.nil?()
          
          bump_all(bump_ver)
        end
        
        desc "Show help for #{name} tasks"
        task :help do
          print_help()
        end
      end
    end
    
    def bump_all(bump_ver)
      sem_ver = []
      
      sem_ver << bump_ruby_files(bump_ver)
      sem_ver << bump_bump_files(bump_ver)
      sem_ver << bump_changelogs(bump_ver)
      
      # FIXME: methods should return nil if no update/change
      if !bump_ver.empty?()
        sem_ver.compact!()
        
        if !sem_ver.empty?()
          version = bump_ver.version.nil?() ? sem_ver[0].to_s() : bump_ver.version
          
          puts 'Git:'
          puts '= ' + (@git_msg % {version: version})
        end
      end
    end
    
    def bump_bump_files(bump_ver)
      return nil
    end
    
    def bump_changelogs(bump_ver)
      return nil
    end
    
    def bump_ruby_files(bump_ver)
      bump_ver_empty = bump_ver.empty?()
      first_sem_ver = nil
      
      @ruby_files.to_a().each do |file|
        puts "[#{file}]:"
        
        if !File.exist?(file)
          puts '! File does not exist'
          
          next
        end
        
        changes = 0
        lines = []
        regex = /\A\s*#{Regexp.quote(@ruby_var)}\s*=\D*/
        
        File.foreach(file) do |line|
          if changes == 0 && !line.strip().empty?() && line =~ regex
            version = line.split(regex,2)
            
            if version.length == 2 && !(version = version[1].strip()).empty?()
              sem_ver = SemVer.parse_line(version)
              
              if !sem_ver.nil?()
                # FIXME: should be nil if no update/change
                first_sem_ver = sem_ver if first_sem_ver.nil?()
                
                if bump_ver_empty
                  puts "= #{sem_ver}"
                  
                  break
                else
                  # FIXME: check if new line = old line; if so, no change
                  bump_ver.bump!(line,sem_ver)
                  puts "+ #{line}"
                  
                  changes += 1
                end
              end
            end
          end
          
          lines << line
        end
        
        next if bump_ver_empty
        
        # TODO: dryrun, write to file if changes, etc.
      end
      
      return first_sem_ver
    end
    
    def print_help()
      puts <<-EOH
rake #{@name} # Print the current version

rake #{@name}[1.2.3-alpha.4-beta.5]       # Set the version manually
rake #{@name} major=1 minor=2 patch=3     # Set the version numbers
rake #{@name} pre=alpha.4 meta=beta.5     # Set the version extensions
rake #{@name} major=+1 minor=+1 patch=+1  # Bump the version numbers by 1
rake #{@name} major=+2 minor=+3 patch=+4  # Bump the version numbers by X

rake #{@name}:major        # Bump the major version by 1
rake #{@name}:major[1]     # Set the major version
rake #{@name}:major[+2]    # Bump the major version by 2
rake #{@name}:minor        # Bump the minor version by 1
rake #{@name}:minor[2]     # Set the minor version
rake #{@name}:minor[+3]    # Bump the minor version by 3
rake #{@name}:patch        # Bump the patch version by 1
rake #{@name}:patch[3]     # Set the patch version
rake #{@name}:patch[+4]    # Bump the patch version by 4
rake #{@name}:pre          # Clear the pre-release version
rake #{@name}:pre[alpha.4] # Set the pre-release version
rake #{@name}:meta         # Clear the build metadata
rake #{@name}:meta[beta.5] # Set the build metadata
      EOH
    end
  end
  
  # TODO: move into own file
  # Semantic Version
  # https://semver.org
  class SemVer
    REGEX = /\d+(\.\d+)?(\.\d+)?(\-[0-9A-Za-z\-\.]+)?(\+[0-9A-Za-z\-\.]+)?/
    
    attr_accessor :major
    attr_accessor :metadata
    attr_accessor :minor
    attr_accessor :patch
    attr_accessor :prerelease
    attr_accessor :version
    
    def initialize(major: nil,minor: nil,patch: nil,prerelease: nil,metadata: nil)
      @major = major
      @metadata = metadata
      @minor = minor
      @patch = patch
      @prerelease = prerelease
    end
    
    def self.parse(str)
      metadata = str.split('+',2)
      prerelease = metadata[0].split('-',2)
      numbers = prerelease[0].split('.',3)
      
      sem_ver = SemVer.new()
      sem_ver.major = numbers[0].to_i()
      
      if numbers.length >= 2
        minor = numbers[1].strip()
        sem_ver.minor = minor.to_i() unless minor.empty?()
        
        if numbers.length == 3
          patch = numbers[2].strip()
          sem_ver.patch = patch.to_i() unless patch.empty?()
        end
      end
      
      if prerelease.length == 2
        prerelease = prerelease[1].strip()
        sem_ver.prerelease = prerelease unless prerelease.empty?()
      end
      
      if metadata.length == 2
        metadata = metadata[1].strip()
        sem_ver.metadata = metadata unless metadata.empty?()
      end
      
      return sem_ver
    end
    
    def self.parse_line(line)
      str = line[REGEX]
      
      return nil if str.nil?()
      
      str = str.strip()
      
      return nil if str.empty?()
      
      return parse(str)
    end
    
    def to_s()
      s = ''.dup()
      
      if !@version.nil?()
        s << @version
      else
        s << @major.to_s()
        s << ".#{@minor.to_s()}" unless @minor.nil?()
        s << ".#{@patch.to_s()}" unless @patch.nil?()
        s << "-#{@prerelease.to_s()}" unless @prerelease.nil?()
        s << "+#{@metadata.to_s()}" unless @metadata.nil?()
      end
      
      return s
    end
  end
  
  # TODO: move into own file
  # Bump Version
  class BumpVer < SemVer
    def initialize(version: nil,major: nil,minor: nil,patch: nil,prerelease: nil,metadata: nil)
      self.major = major
      self.metadata = metadata
      self.minor = minor
      self.patch = patch
      self.prerelease = prerelease
      self.version = version
    end
    
    def init_int(obj)
      return nil if obj.nil?()
      return obj if obj.is_a?(Integer)
      
      obj = obj.to_s().strip()
      
      return obj if obj.empty?() || obj[0] == '+'
      return obj.to_i()
    end
    
    def init_str(obj)
      return obj.nil?() ? nil : obj.to_s().strip()
    end
    
    def bump!(line,sem_ver)
      if !@version.nil?()
        sem_ver.version = @version
      else
        if !@major.nil?()
          if @major.is_a?(Integer)
            sem_ver.major = @major
          elsif @major.empty?()
            sem_ver.major = 0
          else
            sem_ver.major += @major.to_i()
          end
        end
        
        if !@minor.nil?()
          if @minor.is_a?(Integer)
            sem_ver.minor = @minor
          elsif @minor.empty?()
            sem_ver.minor = nil
          else
            sem_ver.minor += @minor.to_i()
          end
        end
        
        if !@patch.nil?()
          if @patch.is_a?(Integer)
            sem_ver.patch = @patch
          elsif @patch.empty?()
            sem_ver.patch = nil
          else
            sem_ver.patch += @patch.to_i()
          end
        end
        
        if !@prerelease.nil?()
          if @prerelease.empty?()
            sem_ver.prerelease = nil
          else
            sem_ver.prerelease = @prerelease
          end
        end
        
        if !@metadata.nil?()
          if @metadata.empty?()
            sem_ver.metadata = nil
          else
            sem_ver.metadata = @metadata
          end
        end
      end
      
      line.sub!(REGEX,sem_ver.to_s())
    end
    
    def major=(major)
      super(init_int(major))
    end
    
    def metadata=(metadata)
      super(init_str(metadata))
    end
    
    def minor=(minor)
      super(init_int(minor))
    end
    
    def patch=(patch)
      super(init_int(patch))
    end
    
    def prerelease=(prerelease)
      super(init_str(prerelease))
    end
    
    def version=(version)
      @version = init_str(version)
    end
    
    def empty?()
      return @major.nil?() &&
             @metadata.nil?() &&
             @minor.nil?() &&
             @patch.nil?() &&
             @prerelease.nil?() &&
             @version.nil?()
    end
  end
end
