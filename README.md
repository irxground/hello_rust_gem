# hello_rust_gem

[![Gem Version](https://badge.fury.io/rb/hello_rust.svg)](https://badge.fury.io/rb/hello_rust)

This project aims to create a Ruby native extension using Rust with minimal dependencies.

## Usage

```sh
$ gem install hello_rust
```

```ruby
require 'hello_rust'

p HelloRust::VERSION
```


## Confirmed platform

- [x] Windows 10 (64bit) + RubyInstaller (x64)
- [x] Windows 10 (64bit) + RubyInstaller (x86)
- [x] macOS Catalina + rbenv
- [x] Amazon linux 2 (x86_64) + rbenv
