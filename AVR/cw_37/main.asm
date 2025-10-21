// Program odczytuje 4 bajty z tablicy sta?ych zdefiniowanej w pami?ci kodu do rejestrów R20..R23

Main_loop:
	ldi R16, 2
	rcall Square_of_number
	rjmp Main_loop

Square_of_number:
	push R30
	push R31
	push R17

	ldi R17, 0

	ldi R30, low(Table_square<<1) // inicjalizacja rejestru Z
	ldi R31, high(Table_square<<1)
	
	add R30, R16
	adc R31, R17

	lpm R16, Z

	pop R17
	pop R31
	pop R30
	ret

Table_square: .db 0, 1, 4, 9, 16, 25, 36, 49, 64, 81 // UWAGA: liczba bajtów zdeklarowanych w pami?ci kodu musi by? parzysta