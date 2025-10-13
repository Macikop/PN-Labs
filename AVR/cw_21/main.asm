MainLoop:
    rcall DelayNCycles ;
    rjmp MainLoop

DelayNCycles: ;zwyk³a etykieta
    nop
    nop
    rcall SubProgram2
    nop
    ret
;powrót do miejsca wywo³ania

SubProgram2:
    nop
    nop
    nop
    ret