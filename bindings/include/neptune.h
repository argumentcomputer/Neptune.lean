#include <cstdarg>
#include <cstdint>
#include <cstdlib>
#include <ostream>
#include <new>

template<typename T = void>
struct Vec;

extern "C" {

uint8_t (poseidon(Vec<uint8_t> data))[32];

} // extern "C"
