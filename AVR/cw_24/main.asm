MainLoop:
    ldi R24, 1
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
    ldi R25, $07
    ldi R24, $CE
    LoopDelayOneMs:
        sbiw R24, 1
        brbc 1, LoopDelayOneMs
    ret

