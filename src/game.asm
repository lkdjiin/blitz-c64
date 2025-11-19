GAME: {

score: .word 0
level: .word 1
speed: .byte 10

// ---------------------------------------------------------------------
increment_score: {
  IncWord(score)
  rts
} // increment_score

// ---------------------------------------------------------------------
increment_level: {
  IncWord(level)
  rts
} // increment_level

// ---------------------------------------------------------------------
reset_score: {
  lda #0
  sta GAME.score
  sta GAME.score + 1
  rts
} // reset_score

// ---------------------------------------------------------------------
reset_level: {
  lda #1
  sta GAME.level
  sta GAME.level + 1
  rts
} // reset_level

// ---------------------------------------------------------------------
reset_speed: {
  lda #INITIAL_SPEED
  sta GAME.speed
} // reset_speed

// ---------------------------------------------------------------------
speed_up: {
  dec GAME.speed
} // speed_up

} // GAME
