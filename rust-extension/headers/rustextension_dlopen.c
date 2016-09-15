#include "rustextension_dlopen.h"
#include "dlfcn.h"

rustextension_number_fn rustextension_number = 0;
rustextension_precise_time_fn rustextension_precise_time = 0;

#define BIND_FN(SRC, DST)           \
  do {                             \
    fnptr = dlsym(SRC, #DST);       \
    if (!fnptr) {                  \
      return -1;                    \
    }                              \
    *(void**) (&DST) = fnptr;       \
  } while(0)

// Loads librustextension at the specified file location and binds the function
// pointers.
int rustextension_load_librustextension(const char* filename) {
    void* fnptr;
    void* librustextension;

    if (rustextension_precise_time != 0) {
        return 0;
    }

    librustextension = dlopen(filename, RTLD_NOW | RTLD_LOCAL);

    if (!librustextension) {
        return -1;
    }

    BIND_FN(librustextension, rustextension_number);
    BIND_FN(librustextension, rustextension_precise_time);

    return 0;
}
