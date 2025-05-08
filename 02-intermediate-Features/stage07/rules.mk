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
	$(MAKE) -C $(dynamic_lib_dir)
	$(MAKE) -C $(static_lib_dir)
	gcc $(CFLAGS) -c $< -o $@ $(LDFLAGS)

$(obj_dir):
	mkdir -p $(obj_dir)

$(bin_dir):
	mkdir -p $(bin_dir)

