#!/usr/bin/env ruby
# encoding: UTF-8
# frozen_string_literal: true

#--
# This file is part of Raketeer.
# Copyright (c) 2020 Jonathan Bradley Whited (@esotericpig)
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
  # @since  0.2.8
  ###
  class GitHubPkgTask < Rake::TaskLib
    attr_accessor :deps
    attr_accessor :description
    attr_accessor :name
    attr_accessor :username
    
    def initialize(name=:github_pkg)
      super()
      
      @deps = [:build]
      @description = %Q(Publish this project's gem(s) to GitHub Packages)
      @name = name
      @username = nil
      
      yield self if block_given?()
      
      @username = Util.find_github_username() if @username.nil?()
      
      raise "#{self.class.name}.username is nil" if @username.nil?()
      
      define()
    end
    
    def define()
      desc @description
      task @name => Array(@deps) do |task,args|
        sh_cmd = ['gem']
        
        sh_cmd.push('push')
        sh_cmd.push('--key','github')
        sh_cmd.push('--host',"https://rubygems.pkg.github.com/#{username}")
        sh_cmd.push(*Dir.glob(File.join('pkg','*.gem'))) # Is this okay for multiple gems?
        
        sh(*sh_cmd)
      end
    end
  end
end
