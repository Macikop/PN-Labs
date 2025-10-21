.macro LOAD_CONST
    ldi @0, high(@2)
    ldi @1, low(@2)
.endmacro

MainLoop:
	LOAD_CONST R17, R16, 1234
	
	rcall NumberToDigits
	nop
	rjmp MainLoop

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


