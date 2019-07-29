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

require 'raketeer/util'

module Raketeer
  ###
  # @author Jonathan Bradley Whited (@esotericpig)
  # @since  0.2.2
  ###
  class RunTask < Rake::TaskLib
    attr_accessor :bin_dir
    attr_accessor :description
    attr_accessor :executable
    attr_accessor :name
    attr_accessor :run_cmd
    attr_accessor :warning
    
    alias_method :warning?,:warning
    
    def initialize(name=:run)
      super()
      
      @bin_dir = 'bin'
      @description = %Q(Run this project's main file: "rake #{name} -- --version")
      @executable = nil
      @name = name
      @warning = true
      
      @run_cmd = ['ruby']
      @run_cmd += ['-r','rubygems']
      @run_cmd += ['-r','bundler/setup']
      
      # Yield before using changeable vars
      yielf self if block_given?()
      
      @executable = Util.find_main_executable(@bin_dir) if @executable.nil?()
      
      @run_cmd << '-w' if @warning
      @run_cmd << File.join(@bin_dir,@executable)
      
      define()
    end
    
    def define()
      desc @description
      task @name do |task,args|
        first_arg_index = -1
        name_s = @name.to_s()
        
        # Cut out "--silent" for "rake --silent rt:run -- --version",
        # else "--silent" will be sent to the executable.
        ARGV.each_with_index do |arg,i|
          # There could be a namespace and/or args, like "rt:run[true]".
          # Rake task names are case-sensitive.
          if arg.include?(name_s)
            first_arg_index = i + 1
            
            break
          end
        end
        
        # There are args for the run command?
        if first_arg_index >= 0 && first_arg_index < ARGV.length
          run_args = ARGV.slice!(first_arg_index..-1)
          
          # Cut out "--" for "rake run -- --version".
          # For older versions of rake, you didn't need "--", so check for it.
          run_args.slice!(0) if run_args[0] == '--'
          
          @run_cmd += run_args
        end
        
        sh(*@run_cmd)
      end
    end
  end
end
