#include <cstdarg>
#include <cstdint>
#include <cstdlib>
#include <ostream>
#include <new>

template<typename T = void>
struct Vec;

extern "C" {

Vec<uint8_t> poseidon(Vec<uint8_t> data);

} // extern "C"
