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


module Raketeer
  VERSION = '0.2.6'
  
  # @since 0.2.4
  DEP_VERSIONS = {
    'irb' => '~> 1.0'
  }
  
  # @since 0.2.4
  def self.try_require_dev(gem_name)
    begin
      require gem_name
    rescue LoadError => e
      raise e.exception("Add development dependency: '#{gem_name}','#{DEP_VERSIONS[gem_name]}'")
    end
  end
end
