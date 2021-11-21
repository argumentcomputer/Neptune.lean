/* #include "neptune.h" */
#include "lean/lean.h"




/**
 * Free the memory for this hasher. This makes all other references to this
 * address invalid.
 */
/*static inline void neptune_hasher_free(blake3_hasher *self) {*/
/*#ifdef DEBUG*/
/*  printf("neptune_hasher_free");*/
/*#endif*/
/*  // Mark memory as available*/
/*  free(self);*/
/*  self = NULL;*/
/*}*/

/*static void neptune_hasher_finalizer(void *ptr) { blake3_hasher_free(ptr); }*/

/*inline static void neptune_hasher_foreach(void *mod, b_lean_obj_arg fn) {}*/

/*static lean_external_class *g_neptune_hasher_class = NULL;*/

/*static lean_external_class *get_neptune_hasher_class() {*/
/*  if (g_neptune_hasher_class == NULL) {*/
/*    g_neptune_hasher_class = lean_register_external_class(*/
/*        &neptune_hasher_finalizer, &blake3_hasher_foreach);*/
/*  }*/
/*  return g_neptune_hasher_class;*/
/*}*/
/*static inline lean_obj_res neptune_hasher_copy(lean_object *self) {*/
/*#ifdef DEBUG*/
/*  printf("lean_neptune_hasher_copy");*/
/*#endif*/
/*  assert(lean_get_external_class(self) == get_neptune_hasher_class());*/
/*  neptune_hasher *a = (blake3_hasher *)lean_get_external_data(self);*/
/*  neptune_hasher *copy = malloc(sizeof(blake3_hasher));*/
/*  *copy = *a;*/

/*  return lean_alloc_external(get_neptune_hasher_class(), copy);*/
/*}*/

/*extern void neptune_hasher_update(blake3_hasher *self, const void *input,*/
/*                                 size_t input_len);*/

/*extern void neptune_hasher_finalize(const blake3_hasher *self, uint8_t *out,*/
/*                                   size_t out_len);*/
/*lean_obj_res lean_neptune_initialize() {*/
/*  neptune_hasher *a = malloc(sizeof(blake3_hasher));*/
/*  neptune_hasher_init(a);*/
/*  return lean_alloc_external(get_neptune_hasher_class(), a);*/
/*}*/
/*static inline lean_obj_res lean_ensure_exclusive_neptune_hasher(lean_obj_arg a) {*/
/*  if (lean_is_exclusive(a))*/
/*    return a;*/
/*  return neptune_hasher_copy(a);*/
/*}*/

lean_obj_res lean_neptune_poseidon() {
#ifdef DEBUG
  printf("lean_neptune_poseidon");
#endif
  int len = 10;
  lean_object *out = lean_alloc_sarray(1, len, len);
  /* lean_object *a = lean_ensure_exclusive_neptune_hasher(self); */
  /* neptune_hasher_update(lean_get_external_data(a), lean_sarray_cptr(input), */
  /*                      input_len); */
  return out;
}

/**
 * Finalize the hasher and return the hash given the length.
 */
/*lean_obj_res lean_neptune_hasher_finalize(lean_obj_arg self, size_t len) {*/
/*#ifdef DEBUG*/
/*  printf("lean_neptune_hasher_finalize");*/
/*#endif*/
 /* lean_object *out = lean_alloc_sarray(1, len, len); */
/*  lean_object *a = lean_ensure_exclusive_neptune_hasher(self);*/
/*  neptune_hasher_finalize(lean_get_external_data(a), lean_sarray_cptr(out), len);*/
/*  return out;*/
/*}*/
