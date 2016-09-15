extern crate time;

#[no_mangle]
pub extern "C" fn rustextension_number() -> u64 {
    123
}

#[no_mangle]
pub extern "C" fn rustextension_precise_time() -> u64 {
    time::precise_time_ns()
}
