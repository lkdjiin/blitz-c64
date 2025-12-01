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

  SetSpriteProperty(SPRITES_EXTRA_COLOR_1, GREEN)
  SetSpriteProperty(SPRITES_EXTRA_COLOR_2, BLUE)
  SetSpriteProperty(SPRITES_MULTICOLOR, 1)

  SetSpriteProperty(SPRITE_0_X, 24)
  SetSpriteProperty(SPRITE_0_Y, 50)
  SetSpriteProperty(SPRITE_0_COLOR, WHITE)
  SetSpriteProperty(SPRITE_0_POINTER, $80)
  SetSpriteProperty(SPRITES_ENABLE, %00000001)

  SetSpriteProperty(SPRITE_1_X, 100)
  SetSpriteProperty(SPRITE_1_Y, 0)
  SetSpriteProperty(SPRITE_1_COLOR, LIGHT_RED)
  SetSpriteProperty(SPRITE_1_POINTER, $83)

  SetBlackBackground()

  jsr init_character_set
  jsr init_irq
  jsr INFOZONE.draw
  jsr INFOZONE.display_score
  jsr INFOZONE.display_level
  jsr draw_town
  rts

// ---------------------------------------------------------------------
init_character_set:
  // Character set at $3000 and VRAM at $0400.
  lda #%00011100
  sta MEMORY_SETUP

  // Multicolor character mode on.
  lda #%11011000
  sta SCREEN_CONTROL_2

  lda #BLACK
  sta BORDER
  // FIXME Why do I need 15 to mean yellow? Is it a bug in VICE, or in my code?
  // Is there something special with multicolor mode?
  lda #11
  sta COLOR_CURRENT
  lda #LIGHT_BLUE
  sta EXTRA_COLOR_1
  lda #WHITE
  sta EXTRA_COLOR_2
  ClearScreen()
  rts

// ---------------------------------------------------------------------
draw_town: {
  StoreWord(SCREEN_ROW_24, TOWER_BASE_PTR)
  RandomRange(3, 12)
  sta tower_height
  ldy town_left_column
  RandomRange(0, 4)
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

// ---------------------------------------------------------------------
init_irq: {
  sei
  lda #%01111111                   // ??? Not clear why we
  sta INTERRUPT_CONTROL_AND_STATUS // ??? need this
  lda INTERRUPT_CONTROL // Enable raster interrupt
  ora #%00000001
  sta INTERRUPT_CONTROL
  lda SCREEN_CONTROL // Clear bit#8 of raster line interrupt
  and #%01111111
  sta SCREEN_CONTROL
  lda #255
  sta RASTER_LINE
  // So now raster line #255 will generate an interrupt
  lda #<irq1
  sta INTERRUPT_SERVICE_ROUTINE_ADDRESS
  lda #>irq1
  sta INTERRUPT_SERVICE_ROUTINE_ADDRESS+1
  cli
  rts
}
