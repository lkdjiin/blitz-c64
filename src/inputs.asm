// ---------------------------------------------------------------------
inputs:
  {
    // if any keypress then launch a bomb
    jsr GETIN
    beq then
    jsr BOMB.launch
    then:
  }
  rts
