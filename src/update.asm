// ---------------------------------------------------------------------
update:
  LongDelay(5)
  jsr update_bomb
  jsr update_plane
  jsr detect_plane_collision
  {
    // TODO Plutôt retourner le status de collision dans A et remplacer par
    // seulement :
    // bne next
    // brk
    // next:

    // If `plane_collision` == 1 then exit
    lda #1
    cmp plane_collision
    bne next
    brk // TODO temporary
    next:
  }
  jsr detect_bomb_collison
  {
    // If `bomb_collision` == 1 then exit
    lda #1
    cmp bomb_collision
    bne next
    brk // TODO temporary
    next:
  }
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

  // "Normalise" x and y coords. (the top left corner of the visible screen is
  // 24,50 in pixel.
  //
  // X = X - 24
  sec
  lda plane_x
  sbc #24
  sta plane_x
  // Y = Y - 50
  sec
  lda plane_y
  sbc #50
  sta plane_y

  // Converts x,y in pixels into col,row
  //
  // mul : floor multiple of 8
  // (col,row) = (mul(x)/8, mul(y)/8)
  lda plane_x
  sta col
  lda #%11111000
  and col
  lsr
  lsr
  lsr
  sta col

  lda plane_y
  sta row
  lda #%11111000
  and row
  lsr
  lsr
  lsr
  sta row

  // Target location in VRAM to spot a tower : (col,row) = (col+3, row+1)
  inc col
  inc col
  inc col
  inc row

  // location = VRAM + (40 * r) + c
  // If location != 0 then collision
  {
    // Put row (8bits) into LOCATION (16bits)
    lda #0
    sta LOCATION_PTR + 1
    lda row
    sta LOCATION_PTR

    // To multiply by 40 => shift shift add shift shift shift
    ShiftLeftWord(LOCATION_PTR)
    ShiftLeftWord(LOCATION_PTR)
    AddWordMByte(LOCATION_PTR, row) // LOCATION = LOCATION + row
    ShiftLeftWord(LOCATION_PTR)
    ShiftLeftWord(LOCATION_PTR)
    ShiftLeftWord(LOCATION_PTR)

    AddWordMByte(LOCATION_PTR, col) // LOCATION = LOCATION + col (8bits)

    // location = location + VRAM (both 16 bits)
    clc
    lda LOCATION_PTR
    adc vram
    sta LOCATION_PTR
    lda LOCATION_PTR + 1
    adc vram + 1
    sta LOCATION_PTR + 1
  }

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

  // "Normalise" x and y coords. (the top left corner of the visible screen is
  // 24,50 in pixel.
  //
  // X = X - 24
  sec
  lda bomb_x
  sbc #24
  sta bomb_x
  // Y = Y - 50
  sec
  lda bomb_y
  sbc #50
  sta bomb_y

  // Converts x,y in pixels into col,row
  //
  // mul : floor multiple of 8
  // (col,row) = (mul(x)/8, mul(y)/8)
  lda bomb_x
  sta col
  lda #%11111000
  and col
  lsr
  lsr
  lsr
  sta col

  lda bomb_y
  sta row
  lda #%11111000
  and row
  lsr
  lsr
  lsr
  sta row

  // Target location in VRAM to spot a tower : (col,row) = (col+1, row+2)
  inc col
  inc row
  inc row

  // location = VRAM + (40 * r) + c
  // If location != 0 then collision
  {
    // Put row (8bits) into LOCATION (16bits)
    lda #0
    sta LOCATION_PTR + 1
    lda row
    sta LOCATION_PTR

    // To multiply by 40 => shift shift add shift shift shift
    ShiftLeftWord(LOCATION_PTR)
    ShiftLeftWord(LOCATION_PTR)
    AddWordMByte(LOCATION_PTR, row) // LOCATION = LOCATION + row
    ShiftLeftWord(LOCATION_PTR)
    ShiftLeftWord(LOCATION_PTR)
    ShiftLeftWord(LOCATION_PTR)

    AddWordMByte(LOCATION_PTR, col) // LOCATION = LOCATION + col (8bits)

    // location = location + VRAM (both 16 bits)
    clc
    lda LOCATION_PTR
    adc vram
    sta LOCATION_PTR
    lda LOCATION_PTR + 1
    adc vram + 1
    sta LOCATION_PTR + 1
  }

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
