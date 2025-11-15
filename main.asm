BasicUpstart2(start)

#import "6502lib/macros.asm"
#import "c64lib/macros.asm"

start:
  jsr init
game_loop:
  LongDelay(10)

  // jsr update
  // jsr render
  // jsr inputs

  // Read keyboard ------------
  {
    // if GETIN then display_bomb
    jsr GETIN
    beq then
    jsr display_bomb
    then:
  }

  // Update bomb --------------
  inc SPRITE1_Y
  {
    // If Y == 229 then disable bomb
    lda #229
    cmp SPRITE1_Y
    bne then
    jsr disable_bomb
    then:
  }

  // Update plane --------------
  inc SPRITE0_X
  // When X == 0 then increase Y by 8 to make the plane going down
  bne game_loop
  lda SPRITE0_Y
  clc
  adc #8
  sta SPRITE0_Y

  jmp game_loop

  rts

// ---------------------------------------------------------------------
#import "src/init.asm"


// ---------------------------------------------------------------------
display_bomb:
  // Same X as the plane
  lda SPRITE0_X
  sta SPRITE1_X
  // Y in the ~middle~ of the plane
  lda SPRITE0_Y
  sta SPRITE1_Y
  jsr enable_bomb
  rts

// ---------------------------------------------------------------------
enable_bomb:
  lda #%00000010
  ora SPRITES_ENABLE
  sta SPRITES_ENABLE
  rts

// ---------------------------------------------------------------------
disable_bomb:
  lda #%11111101
  and SPRITES_ENABLE
  sta SPRITES_ENABLE
  rts


#import "src/external_routines.asm"

counter: .byte 0
column: .byte 10    // First column of the town
block: .byte 91, 98, 107, 115, 107, 115, 226
width: .byte 12  // Width of the town

*=$2000 "Sprites"
sprite_0:
.byte %00110000,%00000000,%00000000
.byte %00111000,%00000000,%00000000
.byte %00111100,%00000000,%00000000
.byte %00111100,%00000001,%10000000
.byte %00111110,%00000011,%11000000
.byte %00111111,%00001111,%11110001
.byte %00111111,%11111111,%11111101
.byte %11111111,%11111111,%11111111
.byte %11111111,%11111111,%11111101
.byte %00001111,%11111111,%11100001
.byte %00000000,%00001111,%11000000
.byte %00000000,%00011111,%10000000
.byte %00000000,%00111110,%00000000
.byte %00000000,%01111000,%00000000
.byte %00000000,%00000000,%00000000
.byte %00000000,%00000000,%00000000
.byte %00000000,%00000000,%00000000
.byte %00000000,%00000000,%00000000
.byte %00000000,%00000000,%00000000
.byte %00000000,%00000000,%00000000
.byte %00000000,%00000000,%00000000
.byte %00000000
sprite_1:
.byte %00000000,%00000000,%00000000
.byte %00000000,%00000000,%00000000
.byte %00000000,%00000000,%00000000
.byte %00000000,%00000000,%00000000
.byte %00000000,%00000000,%00000000
.byte %00000000,%00000000,%00000000
.byte %00000000,%00000000,%00000000
.byte %00000000,%00000000,%00000000
.byte %00000000,%00000000,%00000000
.byte %00000000,%00000000,%00000000
.byte %00000001,%11000011,%10000000
.byte %00000000,%11100111,%00000000
.byte %00000000,%00100100,%00000000
.byte %00000000,%00011000,%00000000
.byte %00000000,%00011000,%00000000
.byte %00000000,%00111100,%00000000
.byte %00000000,%01111110,%00000000
.byte %00000000,%01111110,%00000000
.byte %00000000,%01111110,%00000000
.byte %00000000,%00111100,%00000000
.byte %00000000,%00011000,%00000000
.byte %00000000
