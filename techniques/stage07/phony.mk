clean:
	rm -rf $(obj_dir) $(bin_dir)
	$(MAKE) -C $(static_lib_dir) clean
	$(MAKE) -C $(dynamic_lib_dir) clean

#At runtime, Linux must know where to find lib.so.
#If it's not in a system path like /usr/lib, you need to tell it:
#first way: run cmd
#       export LD_LIBRARY_PATH=lib1:lib2:...

#second way: using rpath in LDFLAGS
#$$ORIGIN (double dollar for Make escaping) is a special linker
#variable that means “directory containing the executable.”
#       LDFLAGS = -Llib -lmylib -Wl, --enable-new-dtags, -rpath=$$ORIGIN/../lib

#third way: create phony target
#Use @ to suppress the printed command.
run:
	@LD_LIBRARY_PATH=$(dynamic_lib_dir)/lib $(target)

#.PHONY is a special target in a Makefile that tells make
#"this is not a real file — always run the commands associated with it."
#If you have a target like clean, and there's a file named clean in your
#directory, make will think it's up to date and won't run the clean commands.
#By marking it as .PHONY, you tell make to always execute it, regardless of
#whether a file named clean exists.
