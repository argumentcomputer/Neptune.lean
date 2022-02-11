/-
Lean bindings to the Neptune hash function
-/
import Neptune.BinaryTools

namespace Neptune

/-
BLS12-381 pairing-friendly elliptic curve construction
-/
namespace Blstrs

constant SCALAR_BYTES_LE: Nat := 32

/-
A field element of BLS12-381 represeted as a dependent
ByteArray which guarantees the correct byte length.
This is mostly intended as a proof of cocept.
-/
def Scalar : Type := { r : ByteArray // r.size = SCALAR_BYTES_LE }

@[defaultInstance]
instance : Into ByteArray Scalar := ⟨Subtype.val⟩

instance : Into Scalar { r : ByteArray // r.size = SCALAR_BYTES_LE } := ⟨id⟩

instance : Into String Scalar := ⟨toBase64⟩

instance : ToString Scalar := ⟨into⟩

instance : Inhabited Scalar where
  default := ⟨(List.replicate SCALAR_BYTES_LE 0).toByteArray, by simp⟩

end Blstrs

constant HasherPointed : NonemptyType

def Hasher : Type := HasherPointed.type

instance : Nonempty Hasher := HasherPointed.property

@[extern "lean_neptune_poseidon"]
private constant lean_neptune_poseidon (bs : @& ByteArray) : ByteArray

/-
Hash a single Scalar field element.
-/
def poseidon {I: Type u} [Into Blstrs.Scalar I] (input : I) : Blstrs.Scalar :=
  let bytes: Blstrs.Scalar := Into.into input
  let out := lean_neptune_poseidon bytes.val
  if h : out.size = Blstrs.SCALAR_BYTES_LE then
    ⟨out, h⟩
  else
    panic! "Incorrect output size of Scalar" 

end Neptune