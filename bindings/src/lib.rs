use neptune::poseidon::{Poseidon, PoseidonConstants};
use blstrs::Scalar as Fr;
use ff::PrimeField;
use generic_array::sequence::GenericSequence;
use generic_array::typenum::{U11, U8};
use generic_array::GenericArray;

#[no_mangle]
pub extern "C" fn poseidon(data: Vec<u8>) -> Vec<u8> {
    let constants = PoseidonConstants::new_with_strength(Strength::Standard);
    let mut h = Poseidon::<F, A>::new(&constants);
    h.input(*scalar).unwrap();
    h.hash_in_mode(HashMode::Correct);
    hasher.input(data);
    hasher.hash().unwrap()
}
