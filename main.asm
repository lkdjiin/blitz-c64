BasicUpstart2(start)

#import "6502lib/macros.asm"
#import "c64lib/macros.asm"
#import "src/constants.asm"

start:
  jsr init
game_loop:
  jsr update
  jsr render
  jsr inputs
  lda game_lost
  bne start
  lda game_won
  bne start
  jmp game_loop
  rts

#import "src/init.asm"
#import "src/update.asm"
#import "src/render.asm"
#import "src/inputs.asm"
#import "src/infozone.asm"
#import "src/variables.asm"
#import "src/external_routines.asm"

*=$2000 "Sprites"
#import "src/sprites_set.asm"
