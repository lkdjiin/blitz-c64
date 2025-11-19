// ---------------------------------------------------------------------
init:
  jsr rnd.init

  lda #0
  sta game_lost
  sta game_won
  sta bomb_on
  sta bomb_collision
  sta plane_collision
  sta block_counter

  lda #TOWN_LEFT_COLUMN
  sta town_left_column
  lda #TOWN_WIDTH
  sta town_width

  SetSpriteProperty(SPRITE0_X, 24)
  SetSpriteProperty(SPRITE0_Y, 50)
  SetSpriteProperty(SPRITE0_COLOR, GREEN)
  SetSpriteProperty(SPRITE0_POINTER, $80)
  SetSpriteProperty(SPRITES_ENABLE, %00000001)

  SetSpriteProperty(SPRITE1_X, 100)
  SetSpriteProperty(SPRITE1_Y, 0)
  SetSpriteProperty(SPRITE1_COLOR, LIGHT_RED)
  SetSpriteProperty(SPRITE1_POINTER, $81)

  SetBlackBackground()
  SetYellowText()
  ClearScreen()

  jsr INFOZONE.draw
  jsr INFOZONE.display_score
  jsr INFOZONE.display_level
  jsr draw_town
  rts

// ---------------------------------------------------------------------
draw_town: {
  StoreWord(SCREEN_ROW_24, TOWER_BASE_PTR)
  RandomRange(3, 11)
  sta tower_height
  ldy town_left_column
  RandomRange(0, 7)
  tax
  lda tower_face,x
  sta BLOCK_PTR
draw_tower:
  inc block_counter
  lda BLOCK_PTR
  sta (TOWER_BASE_PTR),y
  dec tower_height
  beq done_tower
  SubWordLByte(TOWER_BASE_PTR, $28)
  LongDelay(30)
  jmp draw_tower
done_tower:
  dec town_width
  beq done_town
  inc town_left_column
  jmp draw_town
done_town:
  rts
}
