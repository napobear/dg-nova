;This program loads data relatively to its own position in memory. Although
;the bootstrap can be placed anywhere, the usual procedure is to place it in
;high core, beginning at the seventeenth (twenty-first octal) location from
;the top, so that the binary loader also resides in high core. The program is
;shown here for placement at the top of a 4K memory.
;The bootstrap loader reads a tape in a special format in which each word is
;divided into four 4-bit characters. Each character occupies channels 1-4
;(the right half) of a line on the tape. The first character of a word,
;containing bits 0-3, is indicated by a 1 in channel five. The tape can begin
;with any number of blank lines. The first two words are STA 1,.+1 and JMP .-4,
;which are stored in the final two loader locations as indicated in the
;listing. The third, fifth, ... words are STA instructions that address AC1,
;the fourth, sixth, ... words are data. The bootstrap executes each
;odd-numbered word to store the succeeding data word in the location specified
;by the STA instruction. The final odd-numbered word is a HALT, which stops
;the processor.
;In the following listings the first two columns at the left give each memory
;location and its contents for a 4K memory. The remaining columns are a
;standard program listing. To load the program simply use the switches to place
;the octal numbers in the locations specified. For a memory of any other size,
;load the bootstrap beginning at a location whose address is 20 8 less than
;the largest address.

GET:	SUBO	1,1	;Clear AC1, Carry
	SKPDN	PTR
	JMP	.-1	;Wait for done
	DIAS	0,PTR	;Read into AC0 and restart reader

	ADDL	1,1	;Shift AC1 left 4 places
	ADDL	1,1
	ADD	0,1,SNC	;Add in new word
	JMP	GET+1	;Full word not assembled yet

BSTRP:	NIOS	PTR	;Enter here, start reader
	JSR	GET	;Get a word
	STA	1,.+2	;Store it to execute it
	JSR	GET	;Get another word
			;This will contain an STA (first STA 1,.+1)
			;This will contain JMP .-4
