.macro LOAD_CONST
    ldi @0, high(@2)
    ldi @1, low(@2)
.endmacro

.equ Digits_P = PORTB
.equ Segments_P = PORTD

.def Digit_0=R5
.def Digit_1=R4
.def Digit_2=R3
.def Digit_3=R2

ldi R20, (1 << PD0) | (1 << PD1) | (1 << PD2) | (1 << PD3) | (1 << PD4) | (1 << PD5) | (1 << PD6)
ldi R21, (1 << PB1) | (1 << PB2) | (1 << PB3) | (1 << PB4)

ldi R25, (1 << PD0) | (1 << PD1) | (1 << PD2) | (1 << PD3) | (1 << PD4) | (1 << PD5)
ldi R24, (1 << PD1) | (1 << PD2)
ldi R23, (1 << PD0) | (1 << PD1) | (1 << PD3) | (1 << PD4) | (1 << PD6)
ldi R22, (1 << PD0) | (1 << PD1) | (1 << PD2) | (1 << PD3) | (1 << PD6)

mov Digit_0, R25
mov Digit_1, R24
mov Digit_2, R23
mov Digit_3, R22

out DDRD, R20 
out DDRB, R21

LOAD_CONST R17, R16, 5	

out Segments_P, R20

MainLoop:
  
    ldi R21, (1 << PB1)
	out Segments_P, R5
    out Digits_P, R21
    rcall DelayInMs

    ldi R21, (1 << PB2)
	out Segments_P, R4
    out Digits_P, R21
    rcall DelayInMs

    ldi R21, (1 << PB3)
	out Segments_P, R3
    out Digits_P, R21
    rcall DelayInMs

    ldi R21, (1 << PB4)
	out Segments_P, R2
    out Digits_P, R21
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

