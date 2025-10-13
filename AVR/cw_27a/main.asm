MainLoop:
    ldi R24, 3
    ldi R25, 50
    rcall DelayInMs
    rjmp MainLoop

DelayInMs: ;zwyk³a etykieta
    LoopDelayInMs:
        rcall DelayOneMs
        dec R24
        brbc 1, LoopDelayInMs
    ret
;powrót do miejsca wywo³ania

DelayOneMs: ;zwyk³a etykieta
    push R24
    push R25
    ldi R25, $07
    ldi R24, $CE
    LoopDelayOneMs:
        sbiw R24, 1
        brbc 1, LoopDelayOneMs
    pop R25
    pop R24
    ret

