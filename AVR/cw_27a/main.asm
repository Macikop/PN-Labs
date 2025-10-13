MainLoop:
    ldi R24, 3
    ldi R25, 50
    rcall DelayInMs
    rjmp MainLoop

DelayInMs: ;zwyk�a etykieta
    LoopDelayInMs:
        rcall DelayOneMs
        dec R24
        brbc 1, LoopDelayInMs
    ret
;powr�t do miejsca wywo�ania

DelayOneMs: ;zwyk�a etykieta
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

