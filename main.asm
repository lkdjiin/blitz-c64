BasicUpstart2(start)

#import "6502lib/macros.asm"
#import "c64lib/macros.asm"
#import "src/constants.asm"

start:
game_new:
  jsr init
game_loop:
  jsr update
  jsr render
  jsr inputs
  // If lost then reset score and start a new game, else continue
  lda game_lost
  beq continue
  jsr GAME.reset_score
  jmp game_new
continue:
  lda game_won
  bne game_new
  jmp game_loop
  rts

#import "src/init.asm"
#import "src/update.asm"
#import "src/render.asm"
#import "src/inputs.asm"
#import "src/game.asm"
#import "src/infozone.asm"
#import "src/variables.asm"
#import "src/external_routines.asm"

*=$2000 "Sprites"
#import "src/sprites_set.asm"
