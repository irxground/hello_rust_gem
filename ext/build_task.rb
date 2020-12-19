require "json"
require "rake/tasklib"

class BuildTask < Rake::TaskLib
  attr_reader :name, :lib_dir
  attr_reader :manifest_file

  def initialize(name, cargo_dir, lib_dir)
    @name = name
    @lib_dir = lib_dir
    @manifest_file = File.join(cargo_dir, "Cargo.toml")

    define_tasks
  end

  def define_tasks
    target_so_dir = File.join(lib_dir, name)
    target_so = File.join(target_so_dir, "#{name}.#{RbConfig::CONFIG["DLEXT"]}")

    task :cargo do
      unless system "cargo", "-V"
        raise "`cargo` command not found. Please install Rust compiler: https://www.rust-lang.org/"
      end
    end

    desc "Remove build cache"
    task :clean => :cargo do
      sh "cargo", "clean", "--manifest-path", manifest_file
    end

    desc "Remove build cache and compiled library"
    task :clobber => :clean do
      rm_f target_so
    end

    desc "Compile native extension"
    task :build => :cargo do
      env = {}
      if RUBY_PLATFORM =~ /mingw/
        env["RUSTUP_TOOLCHAIN"] = "stable-#{host_cpu}-pc-windows-gnu"
      end
      sh env, "cargo", "build", "--release", "--manifest-path", manifest_file
    end

    directory target_so_dir

    desc "Place compiled library"
    task :install => [:build, target_so_dir] do
      cp cargo_output, target_so, preserve: true, verbose: true
    end
  end

  def host_cpu
    host_cpu = RbConfig::CONFIG["host_cpu"]
    case host_cpu
    when "x64"
      "x86_64"
    else
      host_cpu
    end
  end

  def cargo_output
    metadata = JSON.parse(`cargo metadata --format-version=1 --manifest-path #{manifest_file}`)
    cargo_name = metadata.dig("packages", 0, "name")
    filename = case RUBY_PLATFORM
      when /mingw/; "#{cargo_name}.dll"
      when /darwin/; "lib#{cargo_name}.dylib"
      when /linux/; "lib#{cargo_name}.so"
      else
        raise "'#{}' is not supported RUBY_PLATFORM"
      end
    File.join(metadata["target_directory"], "release", filename)
  end
end
