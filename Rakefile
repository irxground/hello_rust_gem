require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec)

require_relative "ext/build_task.rb"
BuildTask.new("hello_rust", __dir__, File.join(__dir__, "lib/hello_rust"))

task :default => [:clobber, :install, :spec]

task :fmt do
  sh "cargo fmt"
  sh "rufo ."
end
