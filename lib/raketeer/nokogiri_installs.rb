# encoding: UTF-8
# frozen_string_literal: true

#--
# This file is part of Raketeer.
# Copyright (c) 2019-2021 Jonathan Bradley Whited
#++


require 'raketeer/nokogiri_install_tasks'

module Raketeer
  ###
  # Defines all Nokogiri install tasks in your Rakefile.
  #
  # @author Jonathan Bradley Whited
  # @since  0.1.0
  ###
  module NokogiriInstalls
  end
end

Raketeer::NokogiriAPTTask.new # @since 0.1.0
Raketeer::NokogiriDNFTask.new # @since 0.1.0
Raketeer::NokogiriOtherTask.new # @since 0.1.0
