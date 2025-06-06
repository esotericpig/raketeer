# encoding: UTF-8
# frozen_string_literal: true

#--
# This file is part of Raketeer.
# Copyright (c) 2019 Bradley Whited
#
# SPDX-License-Identifier: LGPL-3.0-or-later
#++

module Raketeer
  VERSION = '0.2.14'

  # @since 0.2.4
  def self.try_require_dev(gem_name)
    require gem_name
  rescue LoadError => e
    raise e.exception("Add development dependency: gem '#{gem_name}','~> X.X'")
  end
end
