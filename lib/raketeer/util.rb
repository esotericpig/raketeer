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
  # @author Jonathan Bradley Whited (@esotericpig)
  # @since  0.2.2
  ###
  module Util
    def self.find_main_executable(bin_dir)
      # Try any file
      main_exe = Dir.glob(File.join(bin_dir,'*'))
      
      return File.basename(main_exe[0]) if main_exe.length == 1
      
      # Try only .rb files
      main_exe = Dir.glob(File.join(bin_dir,'*.rb'))
      
      return File.basename(main_exe[0]) if main_exe.length == 1
      
      # Try using the main module
      main_mod = find_main_module()
      
      if !main_mod.nil?()
        main_exe = File.join(bin_dir,main_mod)
        
        return main_mod if File.exist?(main_exe)
      end
      
      return nil
    end
    
    def self.find_main_module()
      # Try the lib/ dir
      main_file = Dir.glob(File.join('lib','*.rb'))
      
      return File.basename(main_file[0],'.*') if main_file.length == 1
      
      # Try the Gemspec
      main_file = Dir.glob('*.gemspec')
      
      return File.basename(main_file[0],'.*') if main_file.length == 1
      
      return nil
    end
  end
end
