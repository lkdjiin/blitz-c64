// ---------------------------------------------------------------------
inputs:
  {
    // if any keypress then display_bomb
    jsr GETIN
    beq then
    jsr display_bomb
    then:
  }
  rts
