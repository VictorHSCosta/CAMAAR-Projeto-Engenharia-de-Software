# frozen_string_literal: true

# The Sys module is a namespace only.
module Sys
  # The Platform class provides singleton methods to tell you what OS you're on.
  class Platform
    # The CPU architecture
    ARCH = File::ALT_SEPARATOR ? Uname.architecture.to_sym : Uname.machine.to_sym

    # Returns a basic OS family, either :windows or :unix
    OS = File::ALT_SEPARATOR ? :windows : :unix

    # Returns the OS type, :macosx, :linux, :mingw32, etc
    IMPL = case Uname.sysname
             when /darwin|mac/i
               :macosx
             when /mingw|windows/i
               require 'rbconfig'
               RbConfig::CONFIG['host_os'].split('_').first[/[a-z]+/i].downcase.to_sym
             when /linux/i
               :linux
             when /bsd|dragonfly/i
               :bsd
           end

    # Returns whether or not you're on a Windows OS
    def self.windows?
      Uname.sysname =~ /microsoft/i ? true : false
    end

    # Returns whether or not you're on a Unixy (non-Windows) OS
    def self.unix?
      Uname.sysname =~ /microsoft/i ? false : true
    end

    # Returns whether or not you're on a mac, i.e. OSX
    def self.mac?
      Uname.sysname =~ /darwin|mac/i ? true : false
    end

    # Returns whether or not you're on Linux
    def self.linux?
      Uname.sysname =~ /linux/i ? true : false
    end

    # Returns whether or not you're on any BSD platform
    def self.bsd?
      Uname.sysname =~ /bsd/i ? true : false
    end
  end
end
