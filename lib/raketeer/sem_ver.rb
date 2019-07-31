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
  ###
  # Semantic Version
  # 
  # This is a non-strict version of Semantic Versioning v2.0.0.
  # 
  # @author Jonathan Bradley Whited (@esotericpig)
  # @since  0.2.4
  # @see    https://semver.org
  ###
  class SemVer
    REGEX = /\d+(\.\d+)?(\.\d+)?(\-[0-9A-Za-z\-\.]+)?(\+[0-9A-Za-z\-\.]+)?/
    
    attr_accessor :build_meta
    attr_accessor :major
    attr_accessor :minor
    attr_accessor :patch
    attr_accessor :prerelease
    attr_accessor :version # If not +nil+, {to_s} will only return this.
    
    def initialize(major: nil,minor: nil,patch: nil,prerelease: nil,build_meta: nil)
      @build_meta = build_meta
      @major = major
      @minor = minor
      @patch = patch
      @prerelease = prerelease
      @version = nil
    end
    
    def initialize_copy(orig)
      super(orig)
      
      @build_meta = orig.build_meta.clone()
      @major = orig.major.clone()
      @minor = orig.minor.clone()
      @patch = orig.patch.clone()
      @prerelease = orig.prerelease.clone()
      @version = orig.version.clone()
    end
    
    def self.parse(str)
      # Parsing backwards makes the logic easier
      build_meta = str.split('+',2)
      prerelease = build_meta[0].split('-',2)
      numbers = prerelease[0].split('.',3)
      
      sem_ver = SemVer.new()
      sem_ver.major = numbers[0].to_i() # There must always be a major version
      
      if numbers.length >= 2
        minor = numbers[1].strip()
        sem_ver.minor = minor.to_i() unless minor.empty?()
        
        if numbers.length == 3
          patch = numbers[2].strip()
          sem_ver.patch = patch.to_i() unless patch.empty?()
        end
      end
      
      if prerelease.length == 2
        prerelease = prerelease[1].strip()
        sem_ver.prerelease = prerelease unless prerelease.empty?()
      end
      
      if build_meta.length == 2
        build_meta = build_meta[1].strip()
        sem_ver.build_meta = build_meta unless build_meta.empty?()
      end
      
      return sem_ver
    end
    
    def self.parse_line(line)
      str = line[REGEX]
      
      return nil if str.nil?() || (str = str.strip()).empty?()
      return parse(str)
    end
    
    def to_s()
      s = ''.dup()
      
      if !@version.nil?()
        s << @version.to_s()
      else
        s << @major.to_s()
        s << ".#{@minor.to_s()}" unless @minor.nil?()
        s << ".#{@patch.to_s()}" unless @patch.nil?()
        s << "-#{@prerelease.to_s()}" unless @prerelease.nil?()
        s << "+#{@build_meta.to_s()}" unless @build_meta.nil?()
      end
      
      return s
    end
  end
end
