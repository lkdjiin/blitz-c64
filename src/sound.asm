SOUND: {

// ---------------------------------------------------------------------
beep: {
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
  lda #2     // Cause a delay of two jiffies
  adc JIFFY_LOW // Add current jiffy reading
  delay:
    cmp JIFFY_LOW // and wait for two jiffies to elapse
    bne delay
  lda #%00010000 // Ungate sound
  sta SID_V1_CONTROL
  rts
} // beep

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
