#ifndef __RUSTEXTENSION_H__
#define __RUSTEXTENSION_H__

#include "stddef.h"
#include "stdint.h"


int rustextension_load_librustextension(const char* filename);
typedef void (*rustextension_init_fn)(char **, char *);
typedef uint64_t (*rustextension_number_fn)();
typedef uint64_t (*rustextension_precise_time_fn)();

extern rustextension_init_fn rustextension_init;
extern rustextension_number_fn rustextension_number;
extern rustextension_precise_time_fn rustextension_precise_time;

#endif
