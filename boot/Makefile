all: boot.rb boot-tti.rb boot-ptr.rb

boot.rb: boot.asm
	dga -l boot.asm

boot-tti.rb: boot-tti.asm
	dga -l boot-tti.asm

boot-ptr.rb: boot-ptr.asm
	dga -l boot-ptr.asm

clean:
	$(RM) *.rb *.lst

distclean: clean
