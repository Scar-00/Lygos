fn main() {
    println!("cargo:rerun-if-changed=src/bindings.cpp");
    println!("cargo:rustc-search=-Lusr/lib");
    println!("cargo:rustc-link-lib=LLVM-18");
    println!("cargo:rustc-link-lib=stdc++");
    let dir = std::env::var("CARGO_MANIFEST_DIR").unwrap();
    println!(
        "cargo:rustc-link-search=native={}",
        std::path::Path::new(&dir).join("src").display()
    );

    cc::Build::new()
        .file("src/bindings.cpp")
        .shared_flag(true)
        .out_dir("src")
        .compile("bindings");
}
