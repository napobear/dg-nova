	.TITL	BOOT
	.LOC	0
BEG:	IORST		;Reset all IO
	READS	0
	LDA	1,C77	;Get device mask (000077)
	AND	0,1	;Isolate device code
	COM	1,1	;-device code - 1

LOOP:	ISZ	OP1	;Count device code into all
	ISZ	OP2	;10 instructions
	ISZ	OP3
	INC	1,1,SZR	;Done?
	JMP	LOOP	;No, increment again

	LDA	2,C377	;Yes, put JMP 377 into location 377
	STA	2,377
OP1:	060077		;Start device; (NIOS 0) - 1
	MOVL	0,0,SZC	;Low speed device? (test switch 0)
C377:	JMP	377	;No, go to 377 and wait for channel

LOOP2:	JSR	GET+1	;Get a frame
	MOVC	0,0,SNR	;Is it nonzero?
	JMP	LOOP2	;No, ignore and get another

LOOP4:	JSR	GET	;Yes, get full word
	STA	1,@C77	;Store starting at 100 (autoincrement)
	ISZ	100	;Count word - done?
	JMP	LOOP4	;No, get another
C77:	JMP	77	;Yes, location counter and jump to last
			;word
GET:	SUBZ	1,1	;Clear AC1, set Carry
OP2:
LOOP3:	063577		;Done? (SKPDN 0) - 1
	JMP	LOOP3	;No, wait
OP3:	060477		;Yes, read in AC0; (DIAS 0,0) - 1
	ADDCS	0,1,SNC	;Add 2 frames swapped - got second?
	JMP	LOOP3	;No, go back after it
	MOVS	1,1	;Yes, swap them
	JMP	0,3	;Return with full word
	0		;Padding
	.END	BEG
