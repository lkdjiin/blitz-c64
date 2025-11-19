INFOZONE: {

draw: {
  StoreWord($0420, LOCATION_PTR)// In vram
  StoreWord($d820, GENERAL_PTR) // In color ram
  StoreWord(map, BLOCK_PTR)

  lda #25 // Height
  sta height

  loop_height:
    ldx #8 // zone width
    loop_width:
      ldy #0
      lda (BLOCK_PTR),y
      sta (LOCATION_PTR),y
      lda #LIGHT_GRAY
      sta (GENERAL_PTR),y
      IncWord(BLOCK_PTR)
      IncWord(LOCATION_PTR)
      IncWord(GENERAL_PTR)
      dex
      bne loop_width
    AddWordLByte(LOCATION_PTR, $20) // Next line in vram
    AddWordLByte(GENERAL_PTR, $20) // Next line in color ram
    dec height
    bne loop_height

  rts

height: .byte 25
} // draw

display_score: {
  SetCursorPosition(34, 8)
  PrintWord(GAME.score)
  rts
} // display_score

map:
.byte $55,$43,$43,$43,$43,$43,$43,$49
.byte $42,$66,$66,$66,$66,$66,$66,$42
.byte $42,$66,$66,$66,$66,$66,$66,$42
.byte $42,$66,$66,$66,$66,$66,$66,$42
.byte $42,$66,$66,$66,$66,$66,$66,$42
.byte $42,$20,$20,$20,$20,$20,$20,$42
.byte $42,$13,$03,$0f,$12,$05,$3a,$42 // SCORE:
.byte $42,$20,$20,$20,$20,$20,$20,$42
.byte $42,$20,$30,$20,$20,$20,$20,$42 //  0
.byte $42,$20,$20,$20,$20,$20,$20,$42
.byte $42,$7f,$7f,$7f,$7f,$7f,$7f,$42
.byte $42,$7f,$7f,$7f,$7f,$7f,$7f,$42
.byte $42,$7f,$7f,$7f,$7f,$7f,$7f,$42
.byte $42,$7f,$7f,$7f,$7f,$7f,$7f,$42
.byte $42,$7f,$7f,$7f,$7f,$7f,$7f,$42
.byte $42,$20,$20,$20,$20,$20,$20,$42
.byte $42,$12,$0f,$15,$0e,$04,$3a,$42 // ROUND:
.byte $42,$20,$20,$20,$20,$20,$20,$42
.byte $42,$20,$20,$30,$30,$20,$20,$42 //   00
.byte $42,$20,$20,$20,$20,$20,$20,$42
.byte $42,$66,$66,$66,$66,$66,$66,$42
.byte $42,$66,$66,$66,$66,$66,$66,$42
.byte $42,$66,$66,$66,$66,$66,$66,$42
.byte $42,$66,$66,$66,$66,$66,$66,$42
.byte $4a,$43,$43,$43,$43,$43,$43,$4b

} // INFOZONE
