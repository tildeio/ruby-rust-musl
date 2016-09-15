require 'rbconfig'
require 'mkmf'

#
# === Setup paths
#
root              = File.expand_path('../', __FILE__)
libpath           = File.expand_path('../../rust-extension/target/dist/x86_64-linux', root)
hdrpath           = File.expand_path('../../rust-extension/headers', root)
librustextension  = File.expand_path("librustextension.so", libpath)
rustextension_dlopen_h = File.expand_path("rustextension_dlopen.h", hdrpath)
rustextension_dlopen_c = File.expand_path("rustextension_dlopen.c", hdrpath)


def find_file(file, root = nil)
  path = File.expand_path(file, root || '.')

  unless File.exist?(path)
    fail "#{file} missing; path=#{root}"
  end
end

$VPATH << hdrpath
$VPATH << libpath

# Where the ruby binding src is
SRC_PATH = File.expand_path('..', __FILE__)

$srcs = Dir[File.expand_path("*.c", SRC_PATH)].map { |f| File.basename(f) }

unless $srcs.include?('rustextension_dlopen.c')
  $srcs << "rustextension_dlopen.c"
end

# Make sure that the files are present
find_file 'rustextension_dlopen.h', hdrpath
find_file 'rustextension_dlopen.c', hdrpath
find_header 'rustextension_dlopen.h', hdrpath
have_header 'dlfcn.h' or fail "could not create Makefile; dlfcn.h missing"

# Flag -std=c99 required for older build systems
$CFLAGS << " -std=c99 -Wall -fno-strict-aliasing"

# Debugging
$CFLAGS << " -g -O0"

create_makefile 'ruby_code_native', File.expand_path('..', __FILE__)
