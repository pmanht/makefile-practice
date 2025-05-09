src_dir = src
obj_dir = obj

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
all: $(objs)

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

#Use -c to compile without linking:

$(obj_dir)/%.o: $(src_dir)/%.c | $(obj_dir)
	gcc -Wall -c -I$(src_dir) $< -o $@

$(obj_dir):
	mkdir -p $(obj_dir)

clean:
	rm -rf $(obj_dir)
