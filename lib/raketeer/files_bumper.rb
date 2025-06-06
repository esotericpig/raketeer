# encoding: UTF-8
# frozen_string_literal: true

#--
# This file is part of Raketeer.
# Copyright (c) 2019 Bradley Whited
#
# SPDX-License-Identifier: LGPL-3.0-or-later
#++

require 'raketeer/bump_ver'
require 'raketeer/sem_ver'

module Raketeer
  # @since 0.2.4
  class FilesBumper
    attr_reader :bump_ver
    attr_reader :bump_ver_empty
    attr_accessor :changes
    attr_reader :dry_run
    attr_reader :files
    attr_accessor :init_per_file
    attr_accessor :line
    attr_accessor :lines
    attr_accessor :sem_ver
    attr_accessor :strict
    attr_accessor :version
    attr_accessor :version_bumped # Was the version actually bumped?

    alias_method :bump_ver_empty?,:bump_ver_empty
    alias_method :dry_run?,:dry_run
    alias_method :strict?,:strict
    alias_method :version_bumped?,:version_bumped

    def initialize(files,bump_ver,dry_run,strict,&init_per_file)
      @bump_ver = bump_ver
      @bump_ver_empty = bump_ver.empty?
      @dry_run = dry_run
      @files = files.to_a
      @init_per_file = init_per_file
      @sem_ver = nil
      @strict = strict
      @version = nil
      @version_bumped = false
    end

    def add_change(line,push: true)
      puts "+ #{line}"

      @changes += 1
      @lines << line if push
    end

    def bump_files
      @files.each do |filename|
        puts "[#{filename}]:"

        if !File.exist?(filename)
          puts '! File does not exist'

          next
        end

        @changes = 0 # For possible future use.
        @lines = []
        @sem_ver = nil

        @init_per_file&.call(self)

        File.foreach(filename) do |line|
          @line = line

          yield(self) if !@line.strip.empty?

          @lines << @line
        end

        next if bump_ver_empty?

        print '= '

        if @changes > 0
          if dry_run?
            puts "Nothing written (dry run): #{@sem_ver}"
          else
            File.open(filename,'w') do |file|
              file.puts @lines
            end

            puts "#{@changes} change#{'s' if @changes == 1} written"
          end
        else
          puts "Nothing written (up-to-date): #{@sem_ver}"
        end
      end
    end

    # @return [:no_ver,:same_ver,:bumped_ver]
    def bump_line!(add_change: true)
      @sem_ver = SemVer.parse_line(@line,strict: @strict)

      return :no_ver if @sem_ver.nil?

      @version = @sem_ver if @version.nil?

      if bump_ver_empty?
        puts "= #{@sem_ver}"

        return :same_ver
      else
        orig_line = @line.dup
        orig_sem_ver_s = @sem_ver.to_s

        @bump_ver.bump_line!(@line,@sem_ver,strict: @strict)

        if @sem_ver.to_s != orig_sem_ver_s
          if !@version_bumped
            @version = @sem_ver
            @version_bumped = true
          end

          self.add_change(@line,push: false) if add_change

          return :bumped_ver
        else
          @line = orig_line

          return :same_ver
        end
      end
    end
  end
end
