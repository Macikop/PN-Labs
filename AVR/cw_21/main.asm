MainLoop:
    rcall DelayNCycles ;
    rjmp MainLoop

DelayNCycles: ;zwyk�a etykieta
    nop
    nop
    rcall SubProgram2
    nop
    ret
;powr�t do miejsca wywo�ania

SubProgram2:
    nop
    nop
    nop
    ret