# encoding: UTF-8
# frozen_string_literal: true

#--
# This file is part of Raketeer.
# Copyright (c) 2019-2021 Jonathan Bradley Whited
#
# SPDX-License-Identifier: LGPL-3.0-or-later
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
  # @author Jonathan Bradley Whited
  # @since  0.2.4
  ###
  class BumpTask < Rake::TaskLib
    attr_accessor :bump_bundle
    attr_accessor :bump_files # Looks for a version number
    attr_accessor :bundle_cmd
    attr_accessor :changelogs # Looks for 'Unreleased' & a Markdown header
    attr_accessor :dry_run
    attr_accessor :git_msg
    attr_accessor :name
    attr_accessor :ruby_files # Looks for {ruby_var}
    attr_accessor :ruby_var
    attr_accessor :strict

    alias_method :bump_bundle?,:bump_bundle
    alias_method :dry_run?,:dry_run
    alias_method :strict?,:strict

    def initialize(name=:bump)
      super()

      @bump_bundle = false
      @bump_files = Rake::FileList[]
      @bundle_cmd = 'bundle'
      @changelogs = Rake::FileList['CHANGELOG.md']
      @dry_run = false
      @git_msg = "git commit -m 'Bump version to v%{version}'"
      @name = name
      @ruby_files = Rake::FileList[File.join('lib','**','version.rb')]
      @ruby_var = 'VERSION'
      @strict = false

      yield self if block_given?
      define
    end

    def define
      desc 'Show/Set/Bump the version'
      task @name,[:version] do |task,args|
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
          bump_ver.major = '+1' if bump_ver.major.nil? || bump_ver.major.empty?

          bump_all(bump_ver)
        end

        desc 'Bump/Set the minor version'
        task :minor,[:minor] do |task,args|
          bump_ver = BumpVer.new(minor: args.minor)
          bump_ver.minor = '+1' if bump_ver.minor.nil?

          bump_all(bump_ver)
        end

        desc 'Bump/Set the patch version'
        task :patch,[:patch] do |task,args|
          bump_ver = BumpVer.new(patch: args.patch)
          bump_ver.patch = '+1' if bump_ver.patch.nil?

          bump_all(bump_ver)
        end

        desc 'Set/Erase the pre-release version'
        task :pre,[:pre] do |task,args|
          bump_ver = BumpVer.new(prerelease: args.pre)
          bump_ver.prerelease = '' if bump_ver.prerelease.nil?

          bump_all(bump_ver)
        end

        desc 'Set/Erase the build metadata'
        task :build,[:build] do |task,args|
          bump_ver = BumpVer.new(build_meta: args.build)
          bump_ver.build_meta = '' if bump_ver.build_meta.nil?

          bump_all(bump_ver)
        end

        desc 'Bump the Gemfile.lock version'
        task :bundle do
          check_env
          bump_bundle_file
        end

        desc "Show the help/usage for #{name} tasks"
        task :help do
          print_help
        end
      end
    end

    def bump_all(bump_ver)
      check_env

      sem_vers = []

      # Order matters for outputting the most accurate version
      sem_vers << bump_ruby_files(bump_ver)
      sem_vers << bump_bump_files(bump_ver)
      sem_vers << bump_changelogs(bump_ver)

      sem_vers.compact!

      if sem_vers.empty?
        puts '! No versions found'

        return
      end

      if @bump_bundle && !bump_ver.empty?
        bump_bundle_file
      end

      # Always output it, in case the user just wants to see what the git message
      # should be without making changes.
      if !@git_msg.nil?
        puts '[Git]:'
        puts '= ' + (@git_msg % {version: sem_vers[0].to_s})
      end
    end

    def bump_bump_files(bump_ver)
      return nil if @bump_files.empty?

      bumper = FilesBumper.new(@bump_files,bump_ver,@dry_run,@strict)

      bumper.bump_files do
        next if bumper.changes > 0 || !bumper.sem_ver.nil?
        next if bumper.line !~ SemVer.regex(@strict)

        break if bumper.bump_line! != :no_ver && bumper.bump_ver_empty?
      end

      return bumper.version
    end

    def bump_bundle_file
      sh_cmd = [@bundle_cmd,'list']

      puts "[#{sh_cmd.join(' ')}]:"

      if @dry_run
        puts '= Nothing written (dry run)'

        return
      end

      sh(*sh_cmd,verbose: false)
    end

    # @see https://keepachangelog.com/en/1.0.0/
    def bump_changelogs(bump_ver)
      return nil if @changelogs.empty?

      bumper = FilesBumper.new(@changelogs,bump_ver,@dry_run,@strict) do
        @header_bumped = false
        @unreleased_bumped = false
      end

      header_regex = /\A(\s*##\s*\[+\D*)(#{SemVer.regex(@strict)})(.*)\z/m
      unreleased_regex = /\A.*Unreleased.*http.*\.{3}/

      bumper.bump_files do
        if @header_bumped && @unreleased_bumped
          break if bumper.bump_ver_empty?
          next
        end

        if bumper.line =~ unreleased_regex
          next if @unreleased_bumped

          # Match from the end, in case the URL has a number (like '%20')
          match = bumper.line.match(/(#{SemVer.regex(@strict)})(\.{3}.*)\z/m)

          next if match.nil? || match.length < 3 || (i = match.begin(0)) < 1

          match = [bumper.line[0..i - 1],match[1],match[-1]]

          next if match.any? {|m| m.nil? || m.strip.empty? }

          orig_line = bumper.line.dup
          bumper.line = match[1]

          if (result = bumper.bump_line!(add_change: false)) != :no_ver
            @unreleased_bumped = true

            if result == :same_ver
              bumper.line = orig_line

              next
            end

            bumper.line = match[0] << bumper.line << match[2]

            bumper.add_change(bumper.line,push: false)
          else
            bumper.line = orig_line
          end
        elsif !(match = bumper.line.match(header_regex)).nil?
          next if @header_bumped || match.length < 4

          match = [match[1],match[2],match[-1]]

          next if match.any? {|m| m.nil? || m.strip.empty? }

          orig_line = bumper.line.dup
          bumper.line = match[1]

          if (result = bumper.bump_line!(add_change: false)) != :no_ver
            @header_bumped = true

            if result == :same_ver
              bumper.line = orig_line

              next
            end

            bumper.line = (match[0] << bumper.line)

            # Replace the date with today's date for the new Markdown header, if it exists
            match[2].sub!(/\d+\s*\-\s*\d+\s*\-\s*\d+(.*)\z/m,"#{Date.today.strftime('%F')}\\1")

            # Fix the link if there is one:
            #   https://github.com/esotericpig/raketeer/compare/v0.2.10...v0.2.11
            versions_regex = /
              (?<beg_ver>#{SemVer.regex(@strict)})
              (?<sep>\.{3}[^\d\s]{,11}) # 11 for 'v', 'version', or something else.
              (?<end_ver>#{SemVer.regex(@strict)})
            /xmi
            versions_match = match[2].match(versions_regex)

            if versions_match
              match[2].sub!(versions_regex,
                "#{versions_match[:end_ver]}" \
                "#{versions_match[:sep]}" \
                "#{bumper.sem_ver}"
              )
            end

            bumper.line << match[2]

            bumper.add_change(bumper.line,push: true)

            # Add after add_change(), so not printed to console.
            bumper.line << "\n\n"
          end

          # We are adding a new Markdown header, so always set the line back to its original value
          bumper.line = orig_line
        end
      end

      return bumper.version
    end

    def bump_ruby_files(bump_ver)
      return nil if @ruby_files.empty?

      bumper = FilesBumper.new(@ruby_files,bump_ver,@dry_run,@strict)
      version_var_regex = /\A(\s*#{Regexp.quote(@ruby_var)}\s*=\D*)(#{SemVer.regex(@strict)})(.*)\z/m

      bumper.bump_files do
        next if bumper.changes > 0 || !bumper.sem_ver.nil?
        next if (match = bumper.line.match(version_var_regex)).nil?
        next if match.length < 4
        next if match[1..2].any? {|m| m.nil? || m.strip.empty? }

        orig_line = bumper.line.dup
        bumper.line = match[2]

        if (result = bumper.bump_line!(add_change: false)) != :no_ver
          if result == :same_ver
            bumper.line = orig_line

            break if bumper.bump_ver_empty?
            next
          end

          bumper.line = match[1] << bumper.line
          bumper.line << match[-1] unless match[-1].nil?

          bumper.add_change(bumper.line,push: false)
        else
          bumper.line = orig_line
        end
      end

      return bumper.version
    end

    def check_env
      @dry_run = Util.get_env_bool('dryrun',@dry_run)
      @strict = Util.get_env_bool('strict',@strict)
    end

    def print_help
      puts <<-HELP
rake #{@name}  # Print the current version

# You can run a dry run for any task (will not write to files)
rake #{@name} dryrun=true

rake #{@name}[1.2.3-alpha.4-beta.5]       # Set the version manually
rake #{@name} major=1 minor=2 patch=3     # Set the version numbers
rake #{@name} pre=alpha.4 build=beta.5    # Set the version extensions
rake #{@name} major=+1 minor=+1 patch=+1  # Bump the version numbers by 1
rake #{@name} major=+2 minor=+3 patch=+4  # Bump the version numbers by X

rake #{@name}:major          # Bump the major version by 1
rake #{@name}:major[1]       # Set the major version to 1
rake #{@name}:major[+2]      # Bump the major version by 2
rake #{@name}:minor          # Bump the minor version by 1
rake #{@name}:minor[2]       # Set the minor version to 2
rake #{@name}:minor[+3]      # Bump the minor version by 3
rake #{@name}:patch          # Bump the patch version by 1
rake #{@name}:patch[3]       # Set the patch version to 3
rake #{@name}:patch[+4]      # Bump the patch version by 4
rake #{@name}:pre            # Erase the pre-release version
rake #{@name}:pre[alpha.4]   # Set the pre-release version
rake #{@name}:build          # Erase the build metadata
rake #{@name}:build[beta.5]  # Set the build metadata
rake #{@name}:bundle         # Bump the Gemfile.lock version
      HELP
    end
  end
end
