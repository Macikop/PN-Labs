// Program odczytuje 4 bajty z tablicy sta?ych zdefiniowanej w pami?ci kodu do rejestrów R20..R23

Main_loop:
	ldi R16, 2
	rcall DigitTo7segCode
	rjmp Main_loop

DigitTo7segCode:
	push R30
	push R31
	push R17

	ldi R17, 0

	ldi R30, low(Table7segCode<<1) // inicjalizacja rejestru Z
	ldi R31, high(Table7segCode<<1)
	
	add R30, R16
	adc R31, R17

	lpm R16, Z

	pop R17
	pop R31
	pop R30
	ret


Table7segCode: .db 0x37, 0x06, 0x63, 0x8F, 0x66, 0x6D, 0x5F, 0x07, 0x7F, 0x6F // UWAGA: liczba bajtów zdeklarowanych w pami?ci kodu musi by? parzysta