# encoding: UTF-8
# frozen_string_literal: true

#--
# This file is part of Raketeer.
# Copyright (c) 2019 Bradley Whited
#
# SPDX-License-Identifier: LGPL-3.0-or-later
#++

require 'raketeer/sem_ver'

module Raketeer
  # Bump Version
  #
  # @since 0.2.4
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
      return obj&.to_s&.strip
    end

    def bump!(sem_ver)
      if !@version.nil?
        sem_ver.version = @version
      else
        if !@major.nil?
          if @major.is_a?(Integer)
            sem_ver.major = @major
          elsif @major.empty?
            sem_ver.major = 0 # There must always be a major version.
          else
            sem_ver.major = 0 if sem_ver.major.nil?

            old_major = sem_ver.major
            sem_ver.major += @major.to_i

            if sem_ver.major != old_major
              # Reset minor & patch so that 1.1.1 => 2.0.0.
              # If the user wishes, minor & patch will continue
              #   to be affected after ('+1.+1.+1').
              sem_ver.minor = 0
              sem_ver.patch = 0

              # It's difficult to decide whether to set
              #   pre-release and build-metadata to nil,
              #   so just leave them.
            end
          end
        end

        if !@minor.nil?
          if @minor.is_a?(Integer)
            sem_ver.minor = @minor
          elsif @minor.empty?
            sem_ver.minor = nil
          else
            sem_ver.minor = 0 if sem_ver.minor.nil?

            old_minor = sem_ver.minor
            sem_ver.minor += @minor.to_i

            if sem_ver.minor != old_minor
              # Reset patch so that 1.1.1 => 1.2.0.
              # If the user wishes, patch will continue
              #   to be affected after ('X.+1.+1').
              sem_ver.patch = 0
            end
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
          sem_ver.prerelease = @prerelease.empty? ? nil : @prerelease
        end
        if !@build_meta.nil?
          sem_ver.build_meta = @build_meta.empty? ? nil : @build_meta
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
