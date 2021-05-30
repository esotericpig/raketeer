# encoding: UTF-8
# frozen_string_literal: true

#--
# This file is part of Raketeer.
# Copyright (c) 2019-2021 Jonathan Bradley Whited
#++


require 'raketeer/sem_ver'

module Raketeer
  ###
  # Bump Version
  #
  # @author Jonathan Bradley Whited
  # @since  0.2.4
  ###
  class BumpVer < SemVer
    def initialize(version: nil,major: nil,minor: nil,patch: nil,prerelease: nil,build_meta: nil)
      super()

      self.build_meta = build_meta
      self.major = major
      self.minor = minor
      self.patch = patch
      self.prerelease = prerelease
      self.version = version
    end

    def init_int_or_str(obj)
      return nil if obj.nil?
      return obj if obj.is_a?(Integer)

      obj = obj.to_s.strip

      return obj if obj.empty? || obj[0] == '+'
      return obj.to_i
    end

    def init_str(obj)
      return obj.nil? ? nil : obj.to_s.strip
    end

    def bump!(sem_ver)
      if !@version.nil?
        sem_ver.version = @version
      else
        if !@major.nil?
          if @major.is_a?(Integer)
            sem_ver.major = @major
          elsif @major.empty?
            sem_ver.major = 0 # There must always be a major version
          else
            sem_ver.major = 0 if sem_ver.major.nil?
            sem_ver.major += @major.to_i
          end
        end

        if !@minor.nil?
          if @minor.is_a?(Integer)
            sem_ver.minor = @minor
          elsif @minor.empty?
            sem_ver.minor = nil
          else
            sem_ver.minor = 0 if sem_ver.minor.nil?
            sem_ver.minor += @minor.to_i
          end
        end

        if !@patch.nil?
          if @patch.is_a?(Integer)
            sem_ver.patch = @patch
          elsif @patch.empty?
            sem_ver.patch = nil
          else
            sem_ver.patch = 0 if sem_ver.patch.nil?
            sem_ver.patch += @patch.to_i
          end
        end

        if !@prerelease.nil?
          if @prerelease.empty?
            sem_ver.prerelease = nil
          else
            sem_ver.prerelease = @prerelease
          end
        end

        if !@build_meta.nil?
          if @build_meta.empty?
            sem_ver.build_meta = nil
          else
            sem_ver.build_meta = @build_meta
          end
        end
      end

      return sem_ver
    end

    def bump_line!(line,sem_ver,strict: false)
      line.sub!(self.class.regex(strict),bump!(sem_ver).to_s)

      return line
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
  end
end
