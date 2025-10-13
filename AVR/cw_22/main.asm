MainLoop:
    ldi R22, 1
    rcall DelayInMs ;
    rjmp MainLoop

DelayInMs: ;zwyk³a etykieta
    Loop_ms:
        ldi R25, $07
        ldi R24, $CF
    Loop:
        sbiw R24, 1
        brbc 1, Loop
        nop
        dec R22
        //nop
        brbc 1, Loop_ms
        
    ret
;powrót do miejsca wywo³ania

