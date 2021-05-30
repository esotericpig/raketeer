# encoding: UTF-8
# frozen_string_literal: true

#--
# This file is part of Raketeer.
# Copyright (c) 2019-2021 Jonathan Bradley Whited
#++


module Raketeer
  VERSION = '0.2.10'

  # @since 0.2.4
  DEP_VERSIONS = {
    'irb' => '>= 1.0'
  }.freeze

  # @since 0.2.4
  def self.try_require_dev(gem_name)
    require gem_name
  rescue LoadError => e
    raise e.exception("Add development dependency: '#{gem_name}','#{DEP_VERSIONS[gem_name]}'")
  end
end
