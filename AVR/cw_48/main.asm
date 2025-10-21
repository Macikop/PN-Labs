.cseg								; segment pami?ci kodu programu
.org 0 rjmp _main			; skok po resecie (do programu g?ównego)


.org OC1Aaddr rjmp _timer_isr		; skok do obs?ugi przerwania timera
.org PCIBaddr rjmp _externar_isr

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
 
 _timer_isr:							; procedura obs?ugi przerwania timera
	push R16
	push R17
	push R18
	push R19
	
	push R20
	
	in R20, SREG

	movw R17:R16, PulseEdgeCtrH:PulseEdgeCtrL
	
	clr PulseEdgeCtrH
	clr PulseEdgeCtrL

	rcall NumberToDigits

	mov Digit_0, R16
	mov Digit_1, R17
	mov Digit_2, R18
	mov Digit_3, R19

	out SREG, R20

	pop R20

	pop R19
	pop R18
	pop R17
	pop R16

reti							; powrót z procedury obs?ugi przerwania (reti zamiast ret)

_externar_isr:
	push R24
	push R25

	in R24, SREG

	inc PulseEdgeCtrL
	brne NoOverflow
		inc PulseEdgeCtrH
	NoOverflow:
	out SREG, R24
	pop R25
	pop R24

reti

_main:
 //Setup

ldi R16, 0x7F // init all segments
out DDRD, R16 
ldi R16, 0x1E // init all digits
out DDRB, R16

clr R0
clr R1

clr Digit_0
clr Digit_1
clr Digit_2
clr Digit_3

//external IRQ
push R16
cli  
out GIMSK, R16				//pin change interrupt
ldi R16, (1 << ISC00) 
out PCMSK0, R16
sei
pop R16

//timer IRQ

push R16
push R17

ldi R16, (1 << WGM12) | (1 << CS12)
out TCCR1B, R16							//TCCR1B - Control Register B  - CTC1 turn on ctc, CS12 - prescaler 256

ldi R16, (1 << OCIE1A)
out TIMSK, R16							//Interrupt mask register - output IRQ if match on A 

ldi R17, 0x7A //7A
ldi R16, 0x11 // 11
out OCR1AH, R17	
out OCR1AL, R16							//Output compare register - compares with counter value, if match generate IRQ

sei										//turn on IRQ

pop R17
pop R16

//End of setup

LOAD_CONST R17, R16, 5 //setting delay


MainLoop:
  
	SET_DIGIT 0 
	SET_DIGIT 1
	SET_DIGIT 2
	SET_DIGIT 3

	rjmp MainLoop

DelayInMs:
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

DelayOneMs:
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
