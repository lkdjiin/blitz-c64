// ---------------------------------------------------------------------
inputs:
  {
    // if any keypress then launch a bomb
    jsr GETIN
    beq then
    jsr launch_bomb
    then:
  }
  rts
