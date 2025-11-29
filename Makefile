CC = java -jar ~/Apps/KickAssembler/KickAss.jar
RUN = x64
CLEANUP = rm -f

.PHONY: clean

all : build run

build : main.asm
	$(CC) main.asm

run: main.prg
	$(RUN) main.prg

debug: main.vs
	$(RUN) -moncommands main.vs main.prg

update_libs:
	rm -rf c64lib/
	cp -r ../c64lib/ .
	echo -n "c64lib " | cat - c64lib/VERSION
	rm -rf 6502lib/
	cp -r ../6502lib/ .
	echo -n "6502lib " | cat - 6502lib/VERSION

clean :
	$(CLEANUP) main.prg main.vs
