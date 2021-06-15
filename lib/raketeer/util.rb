# encoding: UTF-8
# frozen_string_literal: true

#--
# This file is part of Raketeer.
# Copyright (c) 2019-2021 Jonathan Bradley Whited
#
# SPDX-License-Identifier: LGPL-3.0-or-later
#++


module Raketeer
  ###
  # @author Jonathan Bradley Whited
  # @since  0.2.2
  ###
  module Util
    # @since 0.2.4
    TRUE_BOOLS = %w[ 1 on t true y yes ].freeze

    # This is pretty hacky...
    #
    # @since 0.2.8
    def self.find_github_username
      Dir.glob('*.gemspec') do |file|
        File.foreach(file) do |line|
          md = line.match(%r{(github\.com/)([^/]+)}i)

          next if md.nil? || md.length < 3

          return md[2].gsub(/\s+/,'')
        end
      end

      return nil
    end

    def self.find_main_executable(bin_dir='bin')
      # Try the bin/ dir
      main_exe = Dir.glob(File.join(bin_dir,'*'))

      return File.basename(main_exe[0]) if main_exe.length == 1

      # Try using the main module
      main_mod = find_main_module

      if !main_mod.nil?
        main_exe = File.join(bin_dir,main_mod)

        return main_mod if File.exist?(main_exe)
      end

      return nil
    end

    def self.find_main_module(lib_dir='lib')
      # Try the lib/ dir
      main_file = Dir.glob(File.join(lib_dir,'*.rb'))

      return File.basename(main_file[0],'.*') if main_file.length == 1

      # Try the Gemspec
      main_file = Dir.glob('*.gemspec')

      return File.basename(main_file[0],'.*') if main_file.length == 1

      return nil
    end

    # @since 0.2.7
    def self.get_env_bool(env_name,def_value=nil)
      value = ENV[env_name]

      if value.nil? || (value = value.to_s.strip).empty?
        return def_value
      end

      return to_bool(value)
    end

    # @since 0.2.4
    def self.to_bool(obj)
      return TRUE_BOOLS.include?(obj.to_s.downcase)
    end
  end
end
