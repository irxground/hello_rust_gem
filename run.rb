require __dir__ + "/hello_rust"

if defined?(HelloRust)
  puts "HelloRust is defined"
else
  puts "HelloRust is not defined"
end
