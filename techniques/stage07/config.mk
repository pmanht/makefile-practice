#CC: Program for compiling C programs; default cc
#CXX: Program for compiling C++ programs; default g++
#CFLAGS: Extra flags to give to the C compiler
#CXXFLAGS: Extra flags to give to the C++ compiler
#CPPFLAGS: Extra flags to give to the C preprocessor
#LDFLAGS: Extra flags to give to compilers when they
#are supposed to invoke the linker
CC = gcc

CFLAGS = -Wall -Wextra

ifeq ($(DEBUG), 1)
        CFLAGS += -g
else
        #CFLAGS += 01
endif

src_dir = src
obj_dir = obj
bin_dir = bin
static_lib_dir = staticLib
dynamic_lib_dir = dynamicLib

CFLAGS += -I$(src_dir) -I$(static_lib_dir)/include -I$(dynamic_lib_dir)/include

LDFLAGS = -L$(static_lib_dir)/lib -lmyDynamicLib -L$(dynamic_lib_dir)/lib -lmyStaticLib

target := $(bin_dir)/libExam

#One common use of the wildcard function is to get a list
#of all C source files in a directory. For example:
#$(wildcard *.c)
src := $(wildcard $(src_dir)/*.c)

#$(patsubst pattern,replacement,text)
#pattern: The pattern to match, which may contain a % wildcard.
#replacement: The replacement string, which may also contain a %.
#text: The text to search for matches.
objs := $(patsubst $(src_dir)/%.c, $(obj_dir)/%.o, $(src))
