# encoding: UTF-8
# frozen_string_literal: true

#--
# This file is part of Raketeer.
# Copyright (c) 2019 Bradley Whited
#
# SPDX-License-Identifier: LGPL-3.0-or-later
#++

module Raketeer
  #
  # Semantic Version
  #
  # This is a non-strict version of Semantic Versioning v2.0.0.
  #
  # @since 0.2.4
  # @see https://semver.org
  #
  class SemVer
    REGEX = /\d+(\.\d+)?(\.\d+)?(-[0-9A-Za-z\-.]+)?(\+[0-9A-Za-z\-.]+)?/.freeze
    STRICT_REGEX = /\d+\.\d+\.\d+(-[0-9A-Za-z\-.]+)?(\+[0-9A-Za-z\-.]+)?/.freeze

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

    def initialize_dup(orig)
      super
      init_copy(orig,:dup)
    end

    def initialize_clone(orig)
      super
      init_copy(orig,:clone)
    end

    def init_copy(_orig,copy)
      @build_meta = @build_meta.__send__(copy)
      @major = @major.__send__(copy)
      @minor = @minor.__send__(copy)
      @patch = @patch.__send__(copy)
      @prerelease = @prerelease.__send__(copy)
      @version = @version.__send__(copy)
    end

    def self.parse(str)
      # Parsing backwards makes the logic easier
      build_meta = str.split('+',2)
      prerelease = build_meta[0].split('-',2)
      numbers = prerelease[0].split('.',3)

      sem_ver = SemVer.new
      sem_ver.major = numbers[0].to_i # There must always be a major version

      if numbers.length >= 2
        minor = numbers[1].strip
        sem_ver.minor = minor.to_i unless minor.empty?

        if numbers.length == 3
          patch = numbers[2].strip
          sem_ver.patch = patch.to_i unless patch.empty?
        end
      end

      if prerelease.length == 2
        prerelease = prerelease[1].strip
        sem_ver.prerelease = prerelease unless prerelease.empty?
      end

      if build_meta.length == 2
        build_meta = build_meta[1].strip
        sem_ver.build_meta = build_meta unless build_meta.empty?
      end

      return sem_ver
    end

    def self.parse_line(line,strict: false)
      str = line[regex(strict)]

      return nil if str.nil? || (str = str.strip).empty?
      return parse(str)
    end

    def empty?
      return @build_meta.nil? &&
             @major.nil? &&
             @minor.nil? &&
             @patch.nil? &&
             @prerelease.nil? &&
             @version.nil?
    end

    def self.regex(strict = false)
      return strict ? STRICT_REGEX : REGEX
    end

    def to_s
      s = ''.dup

      if !@version.nil?
        s << @version.to_s
      elsif !@major.nil?
        s << @major.to_s
        s << ".#{@minor}" unless @minor.nil?
        s << ".#{@patch}" unless @patch.nil?
        s << "-#{@prerelease}" unless @prerelease.nil?
        s << "+#{@build_meta}" unless @build_meta.nil?
      end

      return s
    end
  end
end
