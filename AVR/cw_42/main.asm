.macro LOAD_CONST
    ldi @0, high(@2)
    ldi @1, low(@2)
.endmacro

MainLoop:
	LOAD_CONST R17, R16, 1200
	LOAD_CONST R19, R18, 500
	rcall Divide
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