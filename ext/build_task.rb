require "json"
require "rake/tasklib"

class BuildTask < Rake::TaskLib
  attr_reader :name, :cargo_dir, :lib_dir

  def initialize(name, cargo_dir, lib_dir)
    @name = name
    @cargo_dir = cargo_dir
    @lib_dir = lib_dir

    define_tasks
  end

  def define_tasks
    artifact = File.join(@lib_dir, "#{@name}.#{RbConfig::CONFIG["DLEXT"]}")
    cargo_toml = File.join(cargo_dir, "Cargo.toml")

    desc "Remove build cache"
    task :clean do
      sh "cargo", "clean", "--manifest-path", cargo_toml
    end

    desc "Remove build cache and compiled library"
    task :clobber => :clean do
      rm_f artifact
    end

    desc "Compile native extension"
    task :build do
      env = {}
      if RUBY_PLATFORM =~ /mingw/
        env["RUSTUP_TOOLCHAIN"] = "stable-#{RbConfig::CONFIG["host_cpu"]}-pc-windows-gnu"
      end
      sh env, "cargo", "build", "--release", "--manifest-path", cargo_toml
    end

    desc "Place compiled library"
    task :install => :build do
      cargo_name = JSON.parse(`cargo metadata --format-version=1 --manifest-path #{cargo_toml}`).dig("packages", 0, "name")
      cargo_out = case RUBY_PLATFORM
        when /mingw/; "target/release/#{cargo_name}.dll"
        when /darwin/; "target/release/lib#{cargo_name}.dylib"
        when /linux/; "target/release/lib#{cargo_name}.so"
        end
      cp cargo_out, artifact, preserve: true, verbose: true
    end
  end
end
