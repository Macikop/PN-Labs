.macro LOAD_CONST
    ldi @0, high(@2)
    ldi @1, low(@2)
.endmacro
	
.macro SET_DIGIT
	push R16
	ldi R21, (1 << (@0 + 1))
	mov R16, Digit_@0
	rcall DigitTo7segCode
	out Segments_P, R16
    out Digits_P, R21
    rcall DelayInMs
.endmacro

.equ Digits_P = PORTB
.equ Segments_P = PORTD

.def Digit_0=R5
.def Digit_1=R4
.def Digit_2=R3
.def Digit_3=R2

ldi R16, 0x7F // init all segments
ldi R16, 0x1E // init all digits

ldi R25, 9
ldi R24, 8
ldi R23, 7
ldi R22, 6

mov Digit_0, R25
mov Digit_1, R24
mov Digit_2, R23
mov Digit_3, R22

out DDRD, R20 
out DDRB, R21

LOAD_CONST R17, R16, 5	

out Segments_P, R20

MainLoop:
  
    SET_DIGIT 0 
	SET_DIGIT 1
	SET_DIGIT 2  
	SET_DIGIT 3 

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

DigitTo7segCode:
	push R30
	push R31

	ldi R30, low(Table7segCode<<1) // inicjalizacja rejestru Z
	ldi R31, high(Table7segCode<<1)
	
	add R30, R16

	lpm R16, Z

	pop R17
	pop R31
	pop R30
	ret


Table7segCode: .db 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F