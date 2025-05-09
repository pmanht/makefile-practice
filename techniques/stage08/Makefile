#CC: Program for compiling C programs; default cc
#CXX: Program for compiling C++ programs; default g++
#CFLAGS: Extra flags to give to the C compiler
#CXXFLAGS: Extra flags to give to the C++ compiler
#CPPFLAGS: Extra flags to give to the C preprocessor
#LDFLAGS: Extra flags to give to compilers when they 
#are supposed to invoke the linker
CC = gcc

#-MMD tells gcc to generate a .d file for each .c, listing its header dependencies.
#-MP adds dummy rules to avoid errors if headers are deleted.
CFLAGS = -Wall -Wextra -MMD -MP

ifeq ($(DEBUG), 1)
	CFLAGS += -g
else
	#CFLAGS += 01
endif

# Installation variables
descdir ?=
prefix ?= /usr/local

src_dir = src
obj_dir = obj
bin_dir = exam
static_lib_dir = staticLib
dynamic_lib_dir = dynamicLib

CFLAGS += -I$(src_dir) -I$(static_lib_dir)/include -I$(dynamic_lib_dir)/include

LDFLAGS = -L$(dynamic_lib_dir)/lib -lmyDynamicLib -L$(static_lib_dir)/lib -lmyStaticLib

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

dep := $(objs:.o=.d)

static_lib := $(static_lib_dir)/lib/libmyStaticLib.a
dynamic_lib := $(dynamic_lib_dir)/lib/libmyDynamicLib.so

#implicit run when we call make cmd
#default target is object files
all: $(dynamic_lib) $(static_lib) $(target)

$(target): $(objs) | $(bin_dir)
	$(CC) $^ -o $@ $(LDFLAGS)

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

# Outputs "hey", since this is the target name
#echo $@
# Outputs all prerequisites newer than the target
#echo $?
# Outputs all prerequisites
#echo $^
# Outputs the first prerequisite
#echo $<

$(dynamic_lib):
	$(MAKE) -C $(dynamic_lib_dir)

$(static_lib):
	$(MAKE) -C $(static_lib_dir)

$(obj_dir)/%.o: $(src_dir)/%.c | $(obj_dir)
	$(CC) $(CFLAGS) -c $< -o $@ $(LDFLAGS)

$(obj_dir):
	mkdir -p $(obj_dir)

$(bin_dir):
	mkdir -p $(bin_dir)

install: $(dynamic_lib) $(static_lib) $(target)
	echo "Installing to $(dest_dir)$(prefix)/$(bin_dir)/"
	mkdir -p $(dest_dir)$(prefix)/$(bin_dir)
	cp $(target) $(dest_dir)$(prefix)/$(bin_dir)
	$(MAKE) -C $(dynamic_lib_dir) install

clean:
	rm -rf $(obj_dir) $(bin_dir)
	$(MAKE) -C $(static_lib_dir) clean
	$(MAKE) -C $(dynamic_lib_dir) clean

uninstall:
	rm -rf $(dest_dir)$(prefix)/$(bin_dir)
	$(MAKE) -C $(dynamic_lib_dir) uninstall

#At runtime, Linux must know where to find lib.so.
#If it's not in a system path like /usr/lib, you need to tell it:
#first way: run cmd
#	export LD_LIBRARY_PATH=lib1:lib2:...

#second way: using rpath in LDFLAGS
#$$ORIGIN (double dollar for Make escaping) is a special linker 
#variable that means “directory containing the executable.”
#	LDFLAGS = -Llib -lmylib -Wl, --enable-new-dtags, -rpath=$$ORIGIN/../lib

#third way: create phony target
#Use @ to suppress the printed command.
run:
	@LD_LIBRARY_PATH=$(dynamic_lib_dir)/lib $(target)

#Includes .d files, if they exist.
#The - prefix prevents errors if the .d file isn’t created yet (like on the first run).
-include $(dep)

#.PHONY is a special target in a Makefile that tells make 
#"this is not a real file — always run the commands associated with it."
#If you have a target like clean, and there's a file named clean in your
#directory, make will think it's up to date and won't run the clean commands.
#By marking it as .PHONY, you tell make to always execute it, regardless of 
#whether a file named clean exists.
.PHONY: clean all run install uninstall
