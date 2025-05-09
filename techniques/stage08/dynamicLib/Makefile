#CC: Program for compiling C programs; default cc
#CXX: Program for compiling C++ programs; default g++
#CFLAGS: Extra flags to give to the C compiler
#CXXFLAGS: Extra flags to give to the C++ compiler
#CPPFLAGS: Extra flags to give to the C preprocessor
#LDFLAGS: Extra flags to give to compilers when they 
#are supposed to invoke the linker
CC = gcc
AR = ar

CFLAGS = -Wall -Wextra -MMD -MP

ifeq ($(DEBUG), 1)
	CFLAGS += -g
else
	#CFLAGS += 01
endif

src_dir = src
obj_dir = obj
tar_dir = lib
inc_dir = include

#To check the standard system locations where Linux searches for
#dynamic libraries (.so files), you can use these methods:
#ld --verbose | grep SEARCH_DIR
#/sbin/ldconfig -v 2>/dev/null | grep -E '^/|libfoo'
sys_lib_dir = /usr/local/lib
sys_inc_dir = /usr/local/include

#-fPIC: Makes the object files position-independent (required for shared libs).
CFLAGS += -fPIC -I$(src_dir)

#-shared: Tells the linker to produce a .so instead of an executable.
LDFLAGS = -shared

tar_name = libmyDynamicLib.so
target := $(tar_dir)/$(tar_name)

#One common use of the wildcard function is to get a list 
#of all C source files in a directory. For example:
#$(wildcard *.c)
src := $(wildcard $(src_dir)/*.c)

inc := $(wildcard $(src_dir)/*.h)

#$(patsubst pattern,replacement,text)
#pattern: The pattern to match, which may contain a % wildcard.
#replacement: The replacement string, which may also contain a %.
#text: The text to search for matches.
objs := $(patsubst $(src_dir)/%.c, $(obj_dir)/%.o, $(src))

dep := $(objs:.o=.d)

#implicit run when we call make cmd
#default target is object files
all: $(target)

# Outputs "hey", since this is the target name
#echo $@
# Outputs all prerequisites newer than the target
#echo $?
# Outputs all prerequisites
#echo $^
# Outputs the first prerequisite
#echo $<

$(target): $(objs) | $(tar_dir) $(inc_dir)
	$(CC) $(CFLAGS) $^ -o $@ $(LDFLAGS)
	cp $(inc) $(inc_dir)

#the part after the pipe symbol |$(obj_dir), specifies
#an order-only prerequisite.
#It’s a dependency that must exist before the rule runs, but 
#does not cause the target to rebuild if it changes.
#We want to ensure the obj/ directory exists before compiling 
#any .c file into .o, but:
#We don’t want the .o files to be recompiled just because the
#directory was created or updated.
#So we use | $(obj_dir) instead of listing $(obj_dir) as a 
#normal prerequisite.

$(obj_dir)/%.o: $(src_dir)/%.c | $(obj_dir)
	$(CC) $(CFLAGS) -c $< -o $@

$(obj_dir):
	mkdir -p $(obj_dir)

$(tar_dir):
	mkdir -p $(tar_dir)

$(inc_dir):
	mkdir -p $(inc_dir)

install: $(target)
	cp $(target) $(sys_lib_dir)
	cp $(inc) $(sys_inc_dir)

clean:
	rm -rf $(obj_dir) $(tar_dir) $(inc_dir)

uninstall:
	rm $(sys_lib_dir)/$(tar_name)
	$(foreach var, $(inc), rm -f $(sys_inc_dir)/$(notdir $(var));)

-include $(dep)

.PHONY: all clean install uninstall
