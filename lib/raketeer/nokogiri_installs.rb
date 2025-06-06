# encoding: UTF-8
# frozen_string_literal: true

#--
# This file is part of Raketeer.
# Copyright (c) 2019 Bradley Whited
#
# SPDX-License-Identifier: LGPL-3.0-or-later
#++

#
# Defines all Nokogiri install tasks in your Rakefile.
#
# @since 0.1.0
#

require 'raketeer/nokogiri_install_tasks'

Raketeer::NokogiriAPTTask.new # @since 0.1.0
Raketeer::NokogiriDNFTask.new # @since 0.1.0
Raketeer::NokogiriOtherTask.new # @since 0.1.0
