use std::ffi;

mod ruby {
    use std::ffi;

    #[repr(transparent)]
    pub struct Value(usize);

    extern "C" {
        // VALUE rb_define_module(const char *name)
        fn rb_define_module(name: *const i8) -> Value;

        // void rb_define_const(VALUE klass, const char *name, VALUE val)
        fn rb_define_const(klass: Value, name: *const i8, val: Value);

        // VALUE rb_str_new(const char *ptr, long len)
        fn rb_str_new(ptr: *const u8, len: usize) -> Value;
    }

    #[inline]
    pub fn define_module(name: &ffi::CStr) -> Value {
        unsafe { rb_define_module(name.as_ptr()) }
    }

    #[inline]
    pub fn define_const(klass: Value, name: &ffi::CStr, val: Value) {
        unsafe { rb_define_const(klass, name.as_ptr(), val) }
    }

    #[inline]
    pub fn new_string(str: &str) -> Value {
        unsafe { rb_str_new(str.as_ptr(), str.len()) }
    }
}

fn cstring(str: &str) -> ffi::CString {
    ffi::CString::new(str).unwrap()
}

#[export_name = "Init_hello_rust"]
pub extern "C" fn init() {
    let module = ruby::define_module(&cstring("HelloRust"));
    let version = ruby::new_string(env!("CARGO_PKG_VERSION"));
    ruby::define_const(module, &cstring("VERSION"), version)
}
