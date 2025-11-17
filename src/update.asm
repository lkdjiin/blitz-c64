// ---------------------------------------------------------------------
update:
  LongDelay(5)
  jsr update_bomb
  jsr update_plane
  jsr detect_plane_collision
  {
    // If `plane_collision` == 1 then exit
    lda #1
    cmp plane_collision
    bne next
    jsr plane_fall
    lda #1
    sta game_lost
    rts
    next:
  }
  jsr detect_bomb_collison
  {
    // If `bomb_collision` == 1 then destroy the tower char
    lda #1
    cmp bomb_collision
    bne next
    jsr destroy_tower_char
    next:
  }
  jsr detect_win
  rts

// ---------------------------------------------------------------------
update_bomb:
  inc SPRITE1_Y
  {
    // If Y == 229 then disable bomb
    lda #229
    cmp SPRITE1_Y
    bne then
    jsr disable_bomb
    then:
  }
  rts

// ---------------------------------------------------------------------
update_plane:
  inc SPRITE0_X
  {
    // If X == 0 then increase Y by 8 to make the plane going down
    bne then
    lda SPRITE0_Y
    clc
    adc #8
    sta SPRITE0_Y
    then:
  }
  rts

// ---------------------------------------------------------------------
launch_bomb:
  lda #1
  cmp bomb_on
  beq launch_bomb_done
  sta bomb_on

  // Same X as the plane, but aligned on the previous multiple of 8, so
  // it's aligned with the towers.
  lda SPRITE0_X
  sta SPRITE1_X
  lda #%11111000
  and SPRITE1_X
  sta SPRITE1_X

  // Appears more or less in the middle of the plane
  lda SPRITE0_Y
  sta SPRITE1_Y

  // Enable_bomb
  lda #%00000010
  ora SPRITES_ENABLE
  sta SPRITES_ENABLE
launch_bomb_done:
  rts

// ---------------------------------------------------------------------
disable_bomb:
  lda #%11111101
  and SPRITES_ENABLE
  sta SPRITES_ENABLE
  lda #0
  sta bomb_on
  rts

// ---------------------------------------------------------------------
// Returns collision status in memory byte `plane_collision`,
// (0 for no collision, 1 for collision).
detect_plane_collision: {
  // Local variables
  jmp after_vars
    plane_x: .byte 0
    plane_y: .byte 0
    col: .byte 0
    row: .byte 0
    vram: .word $0400
  after_vars:

  // Reset return value.
  lda #0
  sta plane_collision

  {
    // If plane X is not a multiple of 8, then exit. Because there is no
    // need to check collision for every plane X position.
    // (if bits 0, 1 and 2 are clear, then it's a multiple of 8)
    lda #%00000111
    and SPRITE0_X
    beq next // We stay here if A == 0
    rts
    next:
  }

  {
    // If plane X position < 64 then exit. Because there is no towers to
    // the left of the screen.
    lda #64
    cmp SPRITE0_X
    bcc next
    rts
    next:
  }

  {
    // If plane X position > 192 then exit. Because no towers to the right
    // of the screen.
    lda #192
    cmp SPRITE0_X
    bcs next
    rts
    next:
  }

  lda SPRITE0_X
  sta plane_x
  lda SPRITE0_Y
  sta plane_y

  ldx plane_x
  ldy plane_y
  jsr normalise_sprite_position

  txa
  jsr convert_coord_px_to_char
  sta col

  tya
  jsr convert_coord_px_to_char
  sta row

  // Target location in VRAM to spot a tower : (col,row) = (col+3, row+1)
  inc col
  inc col
  inc col
  inc row

  ldx col
  ldy row
  jsr convert_char_coord_to_vram_address

  // If location == space character then exit, else plane_collision = 1
  lda #$20
  ldy #0
  cmp (LOCATION_PTR),y
  beq done_collision
  lda #1
  sta plane_collision
  done_collision:
  rts
}

// ---------------------------------------------------------------------
// Returns collision status in memory byte `bomb_collision`,
// (0 for no collision, 1 for collision).
detect_bomb_collison: {
  // Local variables
  jmp after_vars
    bomb_x: .byte 0
    bomb_y: .byte 0
    col: .byte 0
    row: .byte 0
    vram: .word $0400
  after_vars:

  // Reset return value.
  lda #0
  sta bomb_collision

  {
    // If bomb is off, then exit.
    lda #0
    cmp bomb_on
    bne next
    rts
    next:
  }

  {
    // FIXME Problem is the sprite Y start at 50
    // If bomb Y is not a multiple of 8, then exit. Because there is no
    // need to check collision for every position, just the ones that
    // match with characters.
    lda #%00000111
    and SPRITE1_Y
    beq next // We stay here if A == 0
    rts
    next:
  }

  {
    // If bomb Y position < 120 then exit. Because there is no towers to
    // the top of the screen.
    lda #120
    cmp SPRITE1_Y
    bcc next
    rts
    next:
  }

  lda SPRITE1_X
  sta bomb_x
  lda SPRITE1_Y
  sta bomb_y

  ldx bomb_x
  ldy bomb_y
  jsr normalise_sprite_position

  txa
  jsr convert_coord_px_to_char
  sta col

  tya
  jsr convert_coord_px_to_char
  sta row

  // Target location in VRAM to spot a tower : (col,row) = (col+1, row+3)
  inc col
  inc row
  inc row
  inc row

  ldx col
  ldy row
  jsr convert_char_coord_to_vram_address

  // If location == space character then exit, else bomb_collision = 1
  lda #$20
  ldy #0
  cmp (LOCATION_PTR),y
  beq done_collision
  lda #1
  sta bomb_collision
  done_collision:
  rts
}

// ---------------------------------------------------------------------
// Normalise (kind of) x and y coords of a sprite.
// (the top left corner of the visible screen is 24,50 in pixel.)
//
// X - Sprite x
// Y - Sprite y
//
// Returns normalized x and y coords in X and Y.
normalise_sprite_position:
  // x = x - 24
  txa
  sec
  sbc #24
  tax
  // y = y - 50
  tya
  sec
  sbc #50
  tay
  rts

// ---------------------------------------------------------------------
// Converts pixel coord into character coords.
//
// A - A pixel coordinate, either x or y.
//
// Returns A, the character coord.
convert_coord_px_to_char: {
  // Local variables
  jmp after_vars
    temp: .byte 0
  after_vars:

  sta temp
  lda #%11111000 // Floor multiple of 8
  and temp
  lsr
  lsr
  lsr
  rts
}

// ---------------------------------------------------------------------
// Converts char coords into VRAM address of the char.
// Formula : VRAM + (40 * row) + column.
//
// X - character column
// Y - character row
//
// Writes the VRAM address in LOCATION_PTR.
// Destroys A.
convert_char_coord_to_vram_address: {
  // Local variables
  jmp after_vars
    col: .byte 0
    row: .byte 0
    vram: .word $0400
  after_vars:

  // Puts row (8bits) into LOCATION_PTR (16bits)
  lda #0
  sta LOCATION_PTR + 1
  sty LOCATION_PTR

  stx col
  sty row

  // Multiply by 40
  ShiftLeftWord(LOCATION_PTR)     // x 2
  ShiftLeftWord(LOCATION_PTR)     // x 4
  AddWordMByte(LOCATION_PTR, row) // x 5
  ShiftLeftWord(LOCATION_PTR)     // x 10
  ShiftLeftWord(LOCATION_PTR)     // x 20
  ShiftLeftWord(LOCATION_PTR)     // x 40

  AddWordMByte(LOCATION_PTR, col)

  // To finish, add the VRAM base address.
  clc
  lda LOCATION_PTR
  adc vram
  sta LOCATION_PTR
  lda LOCATION_PTR + 1
  adc vram + 1
  sta LOCATION_PTR + 1

  rts
}

// ---------------------------------------------------------------------
destroy_tower_char:
  // VRAM address in LOCATION_PTR must be intact from the previous
  // collision's detection routine.
  lda #$20
  ldy #0
  sta (LOCATION_PTR),y
  rts

// ---------------------------------------------------------------------
plane_fall:
  LongDelay(15)
  inc SPRITE0_Y
  lda #236
  cmp SPRITE0_Y
  bne plane_fall
  LongDelay(255)
  LongDelay(255)
  rts

// ---------------------------------------------------------------------
// Temporary routine to detect win.
detect_win: {
  // If plane is at 255,226 it's a win!
  lda SPRITE0_X
  cmp #255
  bne no
  lda SPRITE0_Y
  cmp #234
  beq yes
  no:
    rts
  yes:
    lda #1
    sta game_won
  rts
}
