.macro LOAD_CONST
    ldi @0, high(@2)
    ldi @1, low(@2)
.endmacro

ldi R20, (1 << PD0) | (1 << PD1) | (1 << PD2) | (1 << PD3) | (1 << PD4) | (1 << PD5) // zero
//ldi R21, (1 << PD1) | (1 << PD2) // one
ldi R22, (1 << PB1) | (1 << PB2) | (1 << PB3) | (1 << PB4)


out DDRD, R20 
out DDRB, R22

LOAD_CONST R17, R16, 250

//ldi R22, (1 << PB1)

//out PORTB, R22

out PORTD, R20

MainLoop:
  
    ldi R22, (1 << PB1)
    out PORTB, R22
    rcall DelayInMs

    ldi R22, (1 << PB2)
    out PORTB, R22
    rcall DelayInMs

    ldi R22, (1 << PB3)
    out PORTB, R22
    rcall DelayInMs

    ldi R22, (1 << PB4)
    out PORTB, R22
    rcall DelayInMs


    rjmp MainLoop

DelayInMs: ;zwyk³a etykieta
    push R25
    push R24
    mov R25, R17
    mov R24, R16
    LoopDelayInMs:
        rcall DelayOneMs
        sbiw R25:R24, 1
        brbc 1, LoopDelayInMs
    pop R24
    pop R25
    ret
;powrót do miejsca wywo³ania

DelayOneMs: ;zwyk³a etykieta
    push R24
    push R25
    LOAD_CONST R25, R24, 0x07CE
    LoopDelayOneMs:
        sbiw R25:R24, 1
        brbc 1, LoopDelayOneMs
    pop R25
    pop R24
    ret
