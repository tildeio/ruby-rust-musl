#include <dlfcn.h>
#include <stdio.h>
#include <ruby.h>
#include <rustextension_dlopen.h>
#include <ruby_code_native.h>


#ifdef HAVE_RUBY_ENCODING_H
#include <ruby/encoding.h>
#endif

#define TO_S(VAL) \
  RSTRING_PTR(rb_funcall(VAL, rb_intern("to_s"), 0))

#define CHECK_TYPE(VAL, T)                        \
  do {                                            \
    if (TYPE(VAL) != T) {                         \
      rb_raise(rb_eArgError, "expected " #VAL " to be " #T " but was '%s' (%s [%i])", \
                TO_S(VAL), rb_obj_classname(VAL), TYPE(VAL)); \
      return Qnil;                                \
    }                                             \
  } while(0)

VALUE rb_mRubyCode;

static char** ruby_code_argv;
static char** ruby_code_envp;

static void
init (int argc, char **argv, char **envp)
{
  ruby_code_argv = argv;
  ruby_code_envp = envp;
}

static void (*const init_array []) ()
  __attribute__ ((section (".init_array"), aligned (sizeof (void *))))
  = { init };

static VALUE
load_librustextension(VALUE klass, VALUE path) {
  int res;

  UNUSED(klass);
  CHECK_TYPE(path, T_STRING);

  // Already loaded
  if (rustextension_init != 0) {
    return Qnil;
  }

  res = rustextension_load_librustextension(StringValueCStr(path));

  if (res < 0) {
    rb_raise(rb_eRuntimeError, "dlerror; msg=%s", dlerror());
    return Qnil;
  }

  rustextension_init(ruby_code_envp, ruby_code_argv[0]);

  return Qnil;
}

static VALUE
number(VALUE self) {
  UNUSED(self);
  return ULL2NUM(rustextension_number());
}

static VALUE
precise_time(VALUE self) {
  UNUSED(self);
  return ULL2NUM(rustextension_precise_time());
}

void Init_ruby_code_native() {
  rb_mRubyCode = rb_define_module("RubyCode");
  rb_define_singleton_method(rb_mRubyCode, "load_librustextension", load_librustextension, 1);
  rb_define_singleton_method(rb_mRubyCode, "number", number, 0);
  rb_define_singleton_method(rb_mRubyCode, "precise_time", precise_time, 0);
}
