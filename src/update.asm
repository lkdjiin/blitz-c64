// ---------------------------------------------------------------------
update:
  LongDelay(10)

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
