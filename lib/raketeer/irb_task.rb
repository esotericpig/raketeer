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

module Raketeer
  ###
  # @author Jonathan Bradley Whited (@esotericpig)
  # @since  0.1.0
  ###
  class IRBTask < Rake::TaskLib
    attr_accessor :description
    attr_accessor :irb_cmd
    attr_accessor :main_module
    attr_accessor :name
    attr_accessor :warning
    
    alias_method :warning?,:warning
    
    def initialize(name=:irb)
      super()
      
      @description = 'Open an irb session loaded with this library'
      @main_module = find_main_module()
      @name = name
      @warning = true
      
      @irb_cmd = ['irb']
      @irb_cmd += ['-r','rubygems']
      @irb_cmd += ['-r','bundler/setup']
      
      # Yield before using changeable vars
      yielf self if block_given?()
      
      @irb_cmd += ['-r',@main_module] unless @main_module.nil?()
      @irb_cmd << '-w' if @warning
      
      define()
    end
    
    def define()
      desc @description
      task @name do |task,args|
        sh(*@irb_cmd)
      end
    end
    
    def find_main_module()
      # First, try the lib/ dir
      main_file = Dir.glob(File.join('lib','*.rb'))
      
      if main_file.length == 1
        basename = File.basename(main_file[0],'.*')
        
        return basename
      end
      
      # Next, try the Gemspec
      main_file = Dir.glob('*.gemspec')
      
      if main_file.length == 1
        basename = File.basename(main_file[0],'.*')
        
        return basename
      end
      
      return nil
    end
  end
end
