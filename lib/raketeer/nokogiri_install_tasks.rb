# encoding: UTF-8
# frozen_string_literal: true

#--
# This file is part of Raketeer.
# Copyright (c) 2019-2021 Jonathan Bradley Whited
#
# SPDX-License-Identifier: LGPL-3.0-or-later
#++


require 'rake'

require 'rake/tasklib'

module Raketeer
  ###
  # @author Jonathan Bradley Whited
  # @since  0.1.0
  ###
  class NokogiriInstallTask < Rake::TaskLib
    attr_accessor :description
    attr_accessor :install_cmd
    attr_accessor :name

    def initialize(name)
      super()

      @description = nil
      @install_cmd = nil
      @name = name
    end

    def define(&block)
      block&.call(self)

      desc @description
      task @name do |task,args|
        run(task,args)
      end
    end

    def run(task,args)
      sh(*@install_cmd)
    end
  end

  ###
  # @author Jonathan Bradley Whited
  # @since  0.1.0
  ###
  class NokogiriAPTTask < NokogiriInstallTask
    def initialize(name=:nokogiri_apt,&block)
      super(name)

      @description = 'Install Nokogiri libs for Ubuntu/Debian'

      @install_cmd = %w[ sudo apt-get install ]
      @install_cmd << 'build-essential'
      @install_cmd << 'libgmp-dev'
      @install_cmd << 'liblzma-dev'
      @install_cmd << 'patch'
      @install_cmd << 'ruby-dev'
      @install_cmd << 'zlib1g-dev'

      define(&block)
    end
  end

  ###
  # @author Jonathan Bradley Whited
  # @since  0.1.0
  ###
  class NokogiriDNFTask < NokogiriInstallTask
    def initialize(name=:nokogiri_dnf,&block)
      super(name)

      @description = 'Install Nokogiri libs for Fedora/CentOS/Red Hat'

      @install_cmd = %w[ sudo dnf install ]
      @install_cmd << 'gcc'
      @install_cmd << 'ruby-devel'
      @install_cmd << 'zlib-devel'

      define(&block)
    end
  end

  ###
  # @author Jonathan Bradley Whited
  # @since  0.1.0
  ###
  class NokogiriOtherTask < NokogiriInstallTask
    def initialize(name=:nokogiri_other,&block)
      super(name)

      @description = 'Install Nokogiri libs for other OSes'

      define(&block)
    end

    def run(task,args)
      puts 'Please go to this link for installing Nokogiri on your system:'
      puts '  https://nokogiri.org/tutorials/installing_nokogiri.html'
    end
  end
end
