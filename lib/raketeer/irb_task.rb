# encoding: UTF-8
# frozen_string_literal: true

#--
# This file is part of Raketeer.
# Copyright (c) 2019-2021 Jonathan Bradley Whited
#
# SPDX-License-Identifier: LGPL-3.0-or-later
#++


require 'rake'

require 'rake/tasklib'

require 'raketeer/util'

module Raketeer
  ###
  # @author Jonathan Bradley Whited
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
      @main_module = Util.find_main_module
      @name = name
      @warning = true

      @irb_cmd = ['irb']
      @irb_cmd.push('-r','rubygems')
      @irb_cmd.push('-r','bundler/setup')

      yield self if block_given?

      @irb_cmd.push('-r',@main_module) unless @main_module.nil?
      @irb_cmd << '-w' if @warning

      define
    end

    def define
      desc @description
      task @name do |task,args|
        sh(*@irb_cmd)
      end
    end
  end
end
