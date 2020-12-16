require 'rake/tasklib'

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

    desc "Remove build cache"
    task :clean do
      sh "cargo", "clean", "--manifest-path", File.join(cargo_dir, "Cargo.toml")
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
      sh env, "cargo", "build", "--release", "--manifest-path", File.join(cargo_dir, "Cargo.toml")
    end

    desc "Place compiled library"
    task :install => :build do
      cargo_out =
        case RUBY_PLATFORM
        when /mingw/ ; "target/release/#{CARGO_NAME}.dll"
        when /darwin/; "target/release/lib#{CARGO_NAME}.dylib"
        when /linux/ ; "target/release/lib#{CARGO_NAME}.so"
        end
      cp cargo_out, artifact, preserve: true, verbose: true
    end
  end
end
