#include "lean/lean.h"
#include "rust/cxx.h"
#include "lean-neptune-bindings/src/lib.rs.h"
#include <vector>


lean_obj_res copy_vector_to_lean_byte_array(std::vector<uint8_t> & vec) {
  uint len = vec.size();
  lean_object *out = lean_alloc_sarray(1, len, len);
  uint8_t* ptr = lean_sarray_cptr(out);
  for (uint i = 0; i < len; i++) {
    *(ptr+i) = vec[i];
  }
  return out;
}

std::vector<uint8_t> lean_byte_array_to_vector(lean_obj_arg bytes) {
  assert(lean_is_sarray(bytes));
  uint8_t* ptr = lean_sarray_cptr(bytes);
  uint len = lean_sarray_size(bytes);
  std::vector<uint8_t> vec(len, len);
  for (uint i = 0; i < len; i++) {
    vec[i] = *(ptr+i);
  }
  return vec;
}


lean_obj_res rust_lean_neptune_poseidon(lean_obj_arg bytes) {
#ifdef DEBUG
  printf("lean_neptune_poseidon");
#endif
  uint len = lean_sarray_size(bytes);
  /* lean_object *out = lean_alloc_sarray(1, len, len); */
  /* lean_object *a = lean_ensure_exclusive_neptune_hasher(self); */
  std::vector<uint8_t> vec(len, len);
  /* vec = lean_sarray_cptr(out); */
  rust::vec<uint8_t> v = poseidon(vec);
  std::vector<uint8_t> stdv;
  std::copy(v.begin(), v.end(), std::back_inserter(stdv));
  return copy_vector_to_lean_byte_array(stdv);
}
