ldi R22, 1


Loop_ms:
    ldi R25, $07
    ldi R24, $CF    //0xFACA
Loop:
    sbiw R24, 1
    brbc 1, Loop
    nop
    dec R22
    brbc 1, Loop_ms
     

End:    
    nop