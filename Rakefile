require 'fileutils'
require 'json'

GEM_NAME = "hello_rust"
CARGO_NAME = JSON.parse(`cargo metadata --format-version=1`).dig("packages", 0, "name")
TARGET_SO = "#{GEM_NAME}.#{RbConfig::CONFIG["DLEXT"]}"

desc "Delete artifacts"
task :clean do
  sh "cargo clean"
  FileUtils.rm_f(TARGET_SO)
end

desc "Create native extension"
task :build do
  env = {}
  case RUBY_PLATFORM
  when /mingw/
    env = {"RUSTUP_TOOLCHAIN" => "stable-#{RbConfig::CONFIG["host_cpu"]}-pc-windows-gnu"}
    cargo_out = "target/release/#{CARGO_NAME}.dll"
  when /darwin/
    cargo_out = "target/release/lib#{CARGO_NAME}.dylib"
  when /linux/
    cargo_out = "target/release/lib#{CARGO_NAME}.so"
  else
    raise "Platform #{RUBY_PLATFORM} is not supported"
  end
  sh env, "cargo build --release"
  cp cargo_out, TARGET_SO, preserve: true, verbose: true
end

desc "Run Ruby script"
task :run => [:clean, :build] do
  ruby "run.rb"
end
