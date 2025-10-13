ldi R22, 255


Loop_ms:
    ldi R17, $F8
    ldi R16, $31     //0xFACA

    //R19 = 0
    ldi R18, 1

Loop:
    add R16, R18
    adc R17, R19
    
    brcc Loop
    dec R22
    brbc 1, Loop_ms
     

End:    
    nop