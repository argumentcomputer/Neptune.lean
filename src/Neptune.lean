/-
Lean bindings to the Neptune hash function
-/
import BinaryTools

namespace Neptune

constant NEPTUNE_OUT_LEN: Nat := 32

/-
A dependent ByteArray which guarantees the correct byte length.
-/
def NeptuneHash : Type := { r : ByteArray // r.size = NEPTUNE_OUT_LEN }

@[defaultInstance]
instance : Into ByteArray NeptuneHash := ⟨Subtype.val⟩

instance : Into String NeptuneHash := ⟨toBase64⟩

instance : ToString NeptuneHash := ⟨into⟩

instance : Inhabited NeptuneHash where
  default := ⟨(List.replicate NEPTUNE_OUT_LEN 0).toByteArray, by simp⟩


constant HasherPointed : PointedType

def Hasher : Type := HasherPointed.type

instance : Inhabited Hasher := ⟨HasherPointed.val⟩

@[extern "lean_neptune_poseidon"]
constant poseidon (bs : ByteArray) : ByteArray

def hash {I: Type u} [Into ByteArray I] (input : I) : NeptuneHash :=
  Inhabited.default
  
