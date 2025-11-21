// ---------------------------------------------------------------------
render: {
  lda SOUND.beep_on
  beq no_current_beep
  jsr SOUND.beep
  no_current_beep:
  rts
}
