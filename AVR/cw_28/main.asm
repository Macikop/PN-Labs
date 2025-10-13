ldi R16, (1 << PB1) | (1 << PB2) | (1 << PB3) | (1 << PB4)
ldi R17, 0

out DDRB, R16


MainLoop:
    
    out PORTB, R16
    out PORTB, R17

    rjmp MainLoop
