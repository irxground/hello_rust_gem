use std::process::Command;

fn rb_config(key: &str) -> String {
    let output = Command::new("ruby")
        .args(&["-e", &format!("print RbConfig::CONFIG['{}']", key)])
        .output()
        .expect("failed run ruby");

    return String::from_utf8(output.stdout).unwrap();
}

fn main() {
    println!("cargo:rustc-link-search={}", rb_config("libdir"));
    println!("cargo:rustc-link-lib={}", rb_config("RUBY_SO_NAME"));
}
