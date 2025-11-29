// ---------------------------------------------------------------------
inputs:
  {
    // if any keypress then launch a bomb
    jsr GETIN
    bne launch
    // or if fire is pressed
    Joystick_1_fire()
    bne then
    launch:
    jsr BOMB.launch
    then:
  }
  rts
