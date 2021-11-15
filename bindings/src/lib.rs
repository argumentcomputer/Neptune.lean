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
