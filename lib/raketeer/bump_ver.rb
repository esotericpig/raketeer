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


require 'raketeer/sem_ver'

module Raketeer
  ###
  # Bump Version
  # 
  # @author Jonathan Bradley Whited (@esotericpig)
  # @since  0.2.4
  ###
  class BumpVer < SemVer
    def initialize(version: nil,major: nil,minor: nil,patch: nil,prerelease: nil,build_meta: nil)
      self.build_meta = build_meta
      self.major = major
      self.minor = minor
      self.patch = patch
      self.prerelease = prerelease
      self.version = version
    end
    
    def init_int_or_str(obj)
      return nil if obj.nil?()
      return obj if obj.is_a?(Integer)
      
      obj = obj.to_s().strip()
      
      return obj if obj.empty?() || obj[0] == '+'
      return obj.to_i()
    end
    
    def init_str(obj)
      return obj.nil?() ? nil : obj.to_s().strip()
    end
    
    def bump!(line,sem_ver)
      if !@version.nil?()
        sem_ver.version = @version
      else
        if !@major.nil?()
          if @major.is_a?(Integer)
            sem_ver.major = @major
          elsif @major.empty?()
            sem_ver.major = 0 # There must always be a major version
          else
            sem_ver.major += @major.to_i()
          end
        end
        
        if !@minor.nil?()
          if @minor.is_a?(Integer)
            sem_ver.minor = @minor
          elsif @minor.empty?()
            sem_ver.minor = nil
          else
            sem_ver.minor += @minor.to_i()
          end
        end
        
        if !@patch.nil?()
          if @patch.is_a?(Integer)
            sem_ver.patch = @patch
          elsif @patch.empty?()
            sem_ver.patch = nil
          else
            sem_ver.patch += @patch.to_i()
          end
        end
        
        if !@prerelease.nil?()
          if @prerelease.empty?()
            sem_ver.prerelease = nil
          else
            sem_ver.prerelease = @prerelease
          end
        end
        
        if !@build_meta.nil?()
          if @build_meta.empty?()
            sem_ver.build_meta = nil
          else
            sem_ver.build_meta = @build_meta
          end
        end
      end
      
      line.sub!(REGEX,sem_ver.to_s())
    end
    
    def build_meta=(build_meta)
      super(init_str(build_meta))
    end
    
    def major=(major)
      super(init_int_or_str(major))
    end
    
    def minor=(minor)
      super(init_int_or_str(minor))
    end
    
    def patch=(patch)
      super(init_int_or_str(patch))
    end
    
    def prerelease=(prerelease)
      super(init_str(prerelease))
    end
    
    def version=(version)
      super(init_str(version))
    end
    
    def empty?()
      return @build_meta.nil?() &&
             @major.nil?() &&
             @minor.nil?() &&
             @patch.nil?() &&
             @prerelease.nil?() &&
             @version.nil?()
    end
  end
end
