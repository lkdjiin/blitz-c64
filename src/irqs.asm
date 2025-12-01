// ---------------------------------------------------------------------
irq1: {
  PushAXY()
  dec INTERRUPT_STATUS // This is an illegible way to acknowledge the raster interrupt
  jsr plane_animation
  PullYXA()
  jmp SYSTEM_IRQ_HANDLER
}

// ---------------------------------------------------------------------
plane_animation: {
  dec animation_delay
  bne done
  lda #PLANE_ANIMATION_DELAY
  sta animation_delay
  ldx animation_counter
  cpx #4
  bne continue
  ldx #0
  stx animation_counter
  continue:
    lda animation_frames,x
    sta SPRITE_0_POINTER
    inc animation_counter
  done:
  rts

animation_frames: .byte $80, $81, $82, $81
animation_delay: .byte PLANE_ANIMATION_DELAY
animation_counter: .byte 0
}

