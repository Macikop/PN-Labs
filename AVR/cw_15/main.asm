ldi R20, 100

OuterLoop:
    ldi R21, 100
InnerLoop:
    nop
    dec R21
    brbc 1, InnerLoop
    dec R20
    brbc 1, OuterLoop

End:
    nop    