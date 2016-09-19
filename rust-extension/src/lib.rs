extern crate time;
extern crate libc;

extern {
  fn __init_libc(envp: *mut *mut libc::c_char, pn: *mut libc::c_char) -> libc::c_void;
}

#[no_mangle]
pub extern "C" fn rustextension_init(envp: *mut *mut libc::c_char, pn: *mut libc::c_char) {
    unsafe {
        __init_libc(envp, pn);
    }
}

#[no_mangle]
pub extern "C" fn rustextension_number() -> u64 {
    123
}

#[no_mangle]
pub extern "C" fn rustextension_precise_time() -> u64 {
    time::precise_time_ns()
}
