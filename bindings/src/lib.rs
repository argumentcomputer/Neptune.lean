use neptune::{
  Strength,
  Arity,
  poseidon::{
    Poseidon,
    PoseidonConstants,
    HashMode,
  },
};
use blstrs::Scalar as Fr;
use ff::PrimeField;
use generic_array::sequence::GenericSequence;
use generic_array::typenum::{U11, U8};
use generic_array::GenericArray;

#[no_mangle]
pub extern "C" fn poseidon(data: Vec<u8>) -> [u8; 32] {
  let constants = PoseidonConstants::new_with_strength(Strength::Standard);
  let mut hasher = Poseidon::<Fr, U11>::new(&constants);
  let scalar = Fr::from(123);
  hasher.input(scalar).unwrap();
  hasher.hash_in_mode(HashMode::Correct).to_bytes_le()
}

#[cxx::bridge]
mod ffi {
    // Any shared structs, whose fields will be visible to both languages.
    struct BlobMetadata {
        size: usize,
        tags: Vec<String>,
    }

    extern "Rust" {
        // Zero or more opaque types which both languages can pass around but
        // only Rust can see the fields.
        // type Poseidon<F>;

        // Functions implemented in Rust.
        fn poseidon(data: Vec<u8>) -> [u8; 32];
    }

    unsafe extern "C++" {
        // One or more headers with the matching C++ declarations. Our code
        // generators don't read it but it gets #include'd and used in static
        // assertions to ensure our picture of the FFI boundary is accurate.
        // include!("demo/include/blobstore.h");

        // Zero or more opaque types which both languages can pass around but
        // only C++ can see the fields.
        // type Poseidon;

        // Functions implemented in C++.
        // fn new_blobstore_client() -> UniquePtr<BlobstoreClient>;
        // fn put(&self, parts: &mut MultiBuf) -> u64;
        // fn tag(&self, blobid: u64, tag: &str);
        // fn metadata(&self, blobid: u64) -> BlobMetadata;
    }
}
