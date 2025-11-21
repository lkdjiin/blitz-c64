SOUND: {

beep_on: .byte 0 // 1 if there is currently a beep playing, else 0
beep_time: .byte 0 // Number of jiffies until end of sound

// ---------------------------------------------------------------------
beep: {
  // If beep_on == 0, then jump start the beep, else jump continue the beep
  lda beep_on
  beq beep_start
  jmp beep_continue
}

// ---------------------------------------------------------------------
beep_start: {
  jsr clear_v1 // Clear the SID chip
  lda #15    // Set the volume
  sta SID_VOLUME
  lda #0     // Set attack/decay
  sta SID_V1_ATTACK_DECAY
  lda #$f0   // Set sustain/release
  sta SID_V1_SUSTAIN_RELEASE
  lda #132   // Set voice 1 frequency (low byte)
  sta SID_V1_FREQUENCY_LOW
  lda #125   // Set voice 1 frequency (high byte)
  sta SID_V1_FREQUENCY_HIGH
  lda #%00010001 // Select triangle waveform and gate sound
  sta SID_V1_CONTROL
  lda #30     // Cause a delay of xxx jiffies
  adc JIFFY_LOW // Add current jiffy reading

  sta beep_time
  lda #1
  sta beep_on
  rts
} // beep

// ---------------------------------------------------------------------
beep_continue: {
  lda beep_time
  cmp JIFFY_LOW
  // If reg < JIFFY_LOW then return, else end the sound
  bcs done
  lda #%00010000 // Ungate sound
  sta SID_V1_CONTROL
  lda #0
  sta beep_on
  done:
  rts
}

// ---------------------------------------------------------------------
// Clear the SID chip.
clear_v1: {
  lda #0  // Fill with zeros
  ldy #24 // Index to FRELO1
  loop:
    sta SID_V1_FREQUENCY_LOW,y // Store in SID chip address
    dey        // For next lower byte
    bpl loop   // Fill 25 bytes
  rts
} // clear_v1

} // SOUND
