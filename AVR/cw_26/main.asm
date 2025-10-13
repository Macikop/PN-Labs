MainLoop:
    ldi R24, 3
    ldi R25, 50
    rcall DelayInMs
    rjmp MainLoop

DelayInMs: ;zwyk³a etykieta
    LoopDelayInMs:
        sts 0x60, R24
        sts 0x61, R25
        rcall DelayOneMs
        lds R24, 0x60
        lds R25, 0x61
        dec R24
        brbc 1, LoopDelayInMs
    ret
;powrót do miejsca wywo³ania

DelayOneMs: ;zwyk³a etykieta
    ldi R25, $07
    ldi R24, $CE
    LoopDelayOneMs:
        sbiw R24, 1
        brbc 1, LoopDelayOneMs
    ret

