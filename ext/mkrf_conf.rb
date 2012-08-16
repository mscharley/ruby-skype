#!/usr/bin/env ruby

require 'rubygems'
require 'rubygems/command.rb'
require 'rubygems/dependency_installer.rb' 

begin
  Gem::Command.build_args = ARGV
rescue NoMethodError
end 

inst = Gem::DependencyInstaller.new
begin
  case RbConfig::CONFIG['host_os']
    when /mingw|cygwin|mswin/
      inst.install "ffi"
    when /linux/
      inst.install "ruby-dbus", '= 0.7.2'
  end
rescue
  exit(1)
end 

f = File.open(File.join(File.dirname(__FILE__), "Rakefile"), "w")   # create dummy rakefile to indicate success
f.write("task :default\n")
f.close
