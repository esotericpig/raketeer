# encoding: UTF-8
# frozen_string_literal: true

#--
# This file is part of Raketeer.
# Copyright (c) 2019 Bradley Whited
#
# SPDX-License-Identifier: LGPL-3.0-or-later
#++

require 'rake'
require 'rake/tasklib'
require 'raketeer/util'

module Raketeer
  #
  # @since 0.2.8
  #
  class GitHubPkgTask < Rake::TaskLib
    attr_accessor :deps
    attr_accessor :description
    attr_accessor :name
    attr_accessor :username

    def initialize(name = :github_pkg)
      super()

      @deps = [:build]
      @description = "Publish this project's gem(s) to GitHub Packages"
      @name = name
      @username = nil

      yield(self) if block_given?

      @username = Util.find_github_username if @username.nil?

      raise "#{self.class.name}.username is nil" if @username.nil?

      define
    end

    def define
      desc @description
      task @name => Array(@deps) do |_task,_args|
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
