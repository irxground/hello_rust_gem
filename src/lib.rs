use std::ffi;

#[repr(transparent)]
pub struct Value(usize);

extern "C" {
    fn rb_define_module(name: *const i8) -> Value;
}

pub fn define_module(name: &ffi::CStr) -> Value {
    unsafe { rb_define_module(name.as_ptr()) }
}

#[export_name = "Init_hello_rust"]
pub extern "C" fn init() {
    let s = ffi::CString::new("HelloRust").unwrap();
    define_module(&s);
}
