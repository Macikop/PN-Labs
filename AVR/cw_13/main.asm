Start: ldi R20, 5
nop //d) cyclec = (R20 * 5) + 5
nop
nop
nop
nop
Loop: dec R20
nop
brbs 1, End
rjmp Loop
End: rjmp Start

// b) cycles = (R20 * 4)
