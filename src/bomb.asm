BOMB: {

// ---------------------------------------------------------------------
launch: {
  lda #1
  cmp bomb_on
  beq launch_bomb_done
  sta bomb_on

  // Same X as the plane, but aligned on the previous multiple of 8, so
  // it's aligned with the towers.
  lda SPRITE_0_X
  sta SPRITE_1_X
  lda #%11111000
  and SPRITE_1_X
  sta SPRITE_1_X

  // Appears more or less in the middle of the plane
  lda SPRITE_0_Y
  sta SPRITE_1_Y

  // Enable_bomb
  lda #%00000010
  ora SPRITES_ENABLE
  sta SPRITES_ENABLE

  jsr SOUND.beep

  launch_bomb_done:
  rts
} // launch

// ---------------------------------------------------------------------
update: {
  inc SPRITE_1_Y
  {
    // If Y == 229 then disable bomb
    lda #229
    cmp SPRITE_1_Y
    bne then
    jsr disable
    then:
  }
  rts
}

// ---------------------------------------------------------------------
disable: {
  lda #%11111101
  and SPRITES_ENABLE
  sta SPRITES_ENABLE
  lda #0
  sta bomb_on
  rts
} // disable

} // BOMB
