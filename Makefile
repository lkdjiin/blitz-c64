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

clean :
	$(CLEANUP) main.prg main.vs
