use std::env;
fn main() {
    let include = env::var("C_INCLUDE_PATH").unwrap();
    cxx_build::bridge("src/lib.rs")
        .file("./c-shim/neptune-shim.cpp")
        .include("include")
        .include(include)
        .compile("lean-neptune-bindings");
}
