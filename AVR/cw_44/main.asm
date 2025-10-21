.macro LOAD_CONST
    ldi @0, high(@2)
    ldi @1, low(@2)
.endmacro
	
.macro SET_DIGIT
	push R16
	ldi R16, (1 << (@0 + 1))
	out Digits_P, R16
	mov R16, Digit_@0
	rcall DigitTo7segCode
    out Segments_P, R16
	pop R16
    rcall DelayInMs
.endmacro

.equ Digits_P = PORTB
.equ Segments_P = PORTD

.def Digit_0=R5
.def Digit_1=R4
.def Digit_2=R3
.def Digit_3=R2

.def PulseEdgeCtrL=R0
.def PulseEdgeCtrH=R1
 
 //Setup

ldi R16, 0x7F // init all segments
out DDRD, R16 
ldi R16, 0x1E // init all digits
out DDRB, R16

clr R0
clr R1


//End of setup

LOAD_CONST R17, R16, 5 //setting delay


MainLoop:
  
	SET_DIGIT 0 
	SET_DIGIT 1
	SET_DIGIT 2
	SET_DIGIT 3

	push R24
	push R25
	push R26
	push R27

	mov R24, R0
	mov R25, R1
	LOAD_CONST R27, R26, 1000
	adiw R25:R24, 1
	cp R24, R26
	cpc R25, R27
	brne L1
		clr R24
		clr R25
	L1:
	mov R0, R24
	mov R1, R25

	pop R27
	pop R26
	pop R25
	pop R24


	push R16
	push R17
	push R18
	push R19

	mov R16, R0
	mov R17, R1

	rcall NumberToDigits

	mov Digit_0, R16
	mov Digit_1, R17
	mov Digit_2, R18
	mov Digit_3, R19

	pop R19
	pop R18
	pop R17
	pop R16


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
	push R17

	ldi R17, 0
	ldi R30, low(Table7segCode<<1) // inicjalizacja rejestru Z
	ldi R31, high(Table7segCode<<1)
	
	add R30, R16
	adc R31, R17

	lpm R16, Z

	pop R17
	pop R31
	pop R30
	ret

Table7segCode: .db 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F

;*** Divide ***
; X/Y -> Quotient,Remainder
; Input/Output: R16-19, Internal R24-25
; inputs
.def XL=R16 ; divident
.def XH=R17
.def YL=R18 ; divisor
.def YH=R19
; outputs
.def RL=R16 ; remainder
.def RH=R17
.def QL=R18 ; quotient
.def QH=R19
; internal
.def QCtrL=R24
.def QCtrH=R25

Divide:
	push QCtrL
	push QCtrH
	clr QCtrL
    clr QCtrH
	Divide_Loop:
		cp XL, YL
		cpc XH, YH
		brlo Exit_Divide
		sub XL, YL
		sbc XH, YH
		adiw QCtrH:QCtrL, 1
		rjmp Divide_Loop
	Exit_Divide:
	mov QH, QCtrH
	mov QL, QCtrL
	pop QCtrH
	pop QCtrL
	ret

;*** NumberToDigits ***
;input : Number: R16-17
;output: Digits: R16-19
;internals: X_R,Y_R,Q_R,R_R - see _Divide
; internals
.def Dig0=R22 ; Digits temps
.def Dig1=R23 ;
.def Dig2=R24 ;
.def Dig3=R25 ;

NumberToDigits:
	push R25
	push R24
	push R23
	push R22

	ldi YL, low(1000)
	ldi YH, high(1000)
	rcall Divide
	mov Dig0, QL

	mov XL, RL
	mov XH, RH
	ldi YL, low(100)
	ldi YH, high(100)
	rcall Divide
	mov Dig1, QL

	mov XL, RL
	mov XH, RH
	ldi YL, low(10)
	ldi YH, high(10)
	rcall Divide
	mov Dig2, QL

	mov Dig3, RL

	mov R16, Dig0
	mov R17, Dig1
	mov R18, Dig2
	mov R19, Dig3

	pop R22
	pop R23
	pop R24
	pop R25
	ret
