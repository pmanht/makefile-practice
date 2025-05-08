#CC: Program for compiling C programs; default cc
#CXX: Program for compiling C++ programs; default g++
#CFLAGS: Extra flags to give to the C compiler
#CXXFLAGS: Extra flags to give to the C++ compiler
#CPPFLAGS: Extra flags to give to the C preprocessor
#LDFLAGS: Extra flags to give to compilers when they 
#are supposed to invoke the linker
CC = gcc

CFLAGS := -Wall -Wextra

ifeq ($(DEBUG), 1)
	CFLAGS += -g
else
	#CFLAGS += 01
endif

src_dir := src
obj_dir := obj
bin_dir := bin
lib_dir := dynamicLib

CFLAGS += -I$(src_dir) -I$(lib_dir)/include

LDFLAGS = -L$(lib_dir)/lib -lmyDynamicLib

target := $(bin_dir)/dynamicLibExam

#One common use of the wildcard function is to get a list 
#of all C source files in a directory. For example:
#$(wildcard *.c)
src := $(wildcard $(src_dir)/*.c)

#$(patsubst pattern,replacement,text)
#pattern: The pattern to match, which may contain a % wildcard.
#replacement: The replacement string, which may also contain a %.
#text: The text to search for matches.
objs := $(patsubst $(src_dir)/%.c, $(obj_dir)/%.o, $(src))

#implicit run when we call make cmd
#default target is object files
all: $(target)

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

$(obj_dir)/%.o: $(src_dir)/%.c | $(obj_dir)
	gcc $(CFLAGS) -c $< -o $@

$(obj_dir):
	mkdir -p $(obj_dir)

$(bin_dir):
	mkdir -p $(bin_dir)

clean:
	rm -rf $(obj_dir) $(bin_dir)

#At runtime, Linux must know where to find lib.so.
#If it's not in a system path like /usr/lib, you need to tell it:
#first way: run cmd
#	export LD_LIBRARY_PATH=lib1:lib2:...

#second way: using rpath in LDFLAGS
#$$ORIGIN (double dollar for Make escaping) is a special linker 
#variable that means “directory containing the executable.”
#	LDFLAGS = -Llib -lmylib -Wl, --enable-new-dtags, -rpath=$$ORIGIN/../lib

#third way: create phony target

run:
	LD_LIBRARY_PATH=$(lib_dir)/lib $(target)

#.PHONY is a special target in a Makefile that tells make 
#"this is not a real file — always run the commands associated with it."
#If you have a target like clean, and there's a file named clean in your
#directory, make will think it's up to date and won't run the clean commands.
#By marking it as .PHONY, you tell make to always execute it, regardless of 
#whether a file named clean exists.
.PHONY: clean all run
