BasicUpstart2(start)

#import "6502lib/macros.asm"
#import "c64lib/macros.asm"
#import "src/constants.asm"

*=* "Main"
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
  jsr GAME.reset_speed
  jsr GAME.reset_level
  jmp game_new
continue:
  // If level won then inc level and new game, else continue
  lda game_won
  beq continue2
  jsr GAME.increment_level
  jsr GAME.speed_up
  jmp game_new
continue2:
  jmp game_loop
  rts

#import "src/init.asm"
#import "src/irqs.asm"
#import "src/update.asm"
#import "src/render.asm"
#import "src/inputs.asm"
#import "src/game.asm"
#import "src/bomb.asm"
#import "src/sound.asm"
#import "src/infozone.asm"
#import "src/variables.asm"
#import "src/external_routines.asm"

*=$2000 "Sprites"
#import "src/sprites_set.asm"
