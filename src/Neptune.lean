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
A dependent ByteArray which guarantees the correct byte length.
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

constant HasherPointed : PointedType

def Hasher : Type := HasherPointed.type

instance : Inhabited Hasher := ⟨HasherPointed.val⟩

@[extern "lean_neptune_poseidon"]
private constant lean_neptune_poseidon (bs : @& ByteArray) : ByteArray

def poseidon {I: Type u} [Into Blstrs.Scalar I] (input : I) : ByteArray :=
  let bytes: Blstrs.Scalar := Into.into input
  lean_neptune_poseidon bytes.val
  
