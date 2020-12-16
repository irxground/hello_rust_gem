require 'fileutils'
require 'json'
require_relative "ext/build_task.rb"

BuildTask.new("hello_rust", __dir__, __dir__)

desc "Run Ruby script"
task :run => [:clobber, :install] do
  ruby "run.rb"
end
