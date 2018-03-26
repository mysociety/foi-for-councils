# frozen_string_literal: true

ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

require 'bundler/setup' # Set up gems listed in the Gemfile.

begin
  require 'bootsnap/setup' # Speed up boot time by caching expensive operations.
rescue LoadError
  STDERR.puts "Couldn't find Bootsnap in the current environment"
end
