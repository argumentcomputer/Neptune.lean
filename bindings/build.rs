
fn main() {
    cxx_build::bridge("src/lib.rs")
        .file("./c-shim/neptune-shim.c")
        .include("include")
        .compile("lean-neptune-bindings");
}
