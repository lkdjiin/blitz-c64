GAME: {

score: .word 0
round: .byte 0

// ---------------------------------------------------------------------
increment_score: {
  IncWord(score)
  rts
} // increment_score

// ---------------------------------------------------------------------
reset_score: {
  lda #0
  sta GAME.score
  sta GAME.score + 1
  rts
} // reset_score

} // GAME
