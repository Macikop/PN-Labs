ldi R22, 255

DelayLoop:
    ldi R20, 186
OuterLoop:
    ldi R21, 10
InnerLoop:
    nop
    dec R21
    brbc 1, InnerLoop
    dec R20
    brbc 1, OuterLoop
    dec R22
    brbc 1, DelayLoop    

End: nop
//When R22 = 255 error ~0.0001%