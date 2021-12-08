import Neptune

def main: IO Unit := do
  -- Needs to be exactly 32 bytes
  let v := #[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19,
    20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32].toList.toByteArray
  if h : v.size = Neptune.Blstrs.SCALAR_BYTES_LE then
    let l: Neptune.Blstrs.Scalar := ⟨v, h⟩
    println! "Poseidon<Fr,U11>({l})={Neptune.poseidon l}"
  else
    panic! "Incorrect input size"
