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


require 'raketeer/bump_ver'
require 'raketeer/sem_ver'

module Raketeer
  ###
  # @author Jonathan Bradley Whited (@esotericpig)
  # @since  0.2.4
  ###
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
    attr_accessor :version
    attr_accessor :version_bumped # Was the version actually bumped?
    
    alias_method :bump_ver_empty?,:bump_ver_empty
    alias_method :dry_run?,:dry_run
    alias_method :version_bumped?,:version_bumped
    
    def initialize(files,bump_ver,dry_run,&init_per_file)
      @bump_ver = bump_ver
      @bump_ver_empty = bump_ver.empty?()
      @dry_run = dry_run
      @files = files.to_a()
      @init_per_file = init_per_file
      @sem_ver = nil
      @version = nil
      @version_bumped = false
    end
    
    def add_change(line,push: true)
      puts "+ #{line}"
      
      @changes += 1
      @lines << line if push
    end
    
    def bump_files(&block)
      @files.each do |filename|
        puts "[#{filename}]:"
        
        if !File.exist?(filename)
          puts '! File does not exist'
          
          next
        end
        
        @changes = 0 # For possible future use
        @lines = []
        @sem_ver = nil
        
        @init_per_file.call(self) unless @init_per_file.nil?()
        
        File.foreach(filename) do |line|
          @line = line
          
          block.call(self) if !@line.strip().empty?()
          
          @lines << @line
        end
        
        next if bump_ver_empty?()
        
        print '= '
        
        if @changes > 0
          if dry_run?()
            puts "Nothing written (dry run): #{@sem_ver}"
          else
            File.open(filename,'w') do |file|
              file.puts @lines
            end
            
            puts "#{@changes} change#{@changes == 1 ? '' : 's'} written"
          end
        else
          puts "Nothing written (up-to-date): #{@sem_ver}"
        end
      end
    end
    
    def bump_line!(add_change: true)
      @sem_ver = SemVer.parse_line(@line)
      
      return false if @sem_ver.nil?()
      
      @version = @sem_ver if @version.nil?()
      
      if bump_ver_empty?()
        puts "= #{@sem_ver}"
        
        return true
      else
        orig_line = @line.dup()
        @bump_ver.bump_line!(@line,@sem_ver)
        
        if @line != orig_line
          if !@version_bumped
            @version = @sem_ver
            @version_bumped = true
          end
          
          self.add_change(@line,push: false) if add_change
          
          return true
        end
      end
      
      return false
    end
  end
end
