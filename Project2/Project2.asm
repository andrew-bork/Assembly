; Program: Project #2
; Author: Andrew Lin
; CMPE 102
; 10/22/23
; Write a program that reads an integer which is an index of one array and copies elements of that array to another array. 

.386
.model flat,stdcall
.stack 4096

; include "Irvine32.inc"
include <Irvine32.inc>

ExitProcess proto exit_code:dword

; Use LOOP, JMP, and conditional jump instructions in the program.
; Use PTR, LENGTHOF, $, ALIGN, and OFFSET

.data
	; Declare two arrays which have five 8-bit elements each.
	array1 BYTE 0, 0, 0, 0, 0
	array1Length dword $ - array1
	array2 BYTE 1, 2, 3, 4, 5

	; Define a 8-bit data label named startIndex.
	startIndex BYTE ?

	; Console messages
	projectTitle byte "--- Array Copier ---", 10, 0
	continueMessage byte "Continue? y/n: ", 0
	indexMessageStart byte "Index (0 - ", 0
	indexMessageEnd byte "): ", 0
	terminationMessage byte "--- Program Terminated ---", 10, 0
	invalidMessage byte "Invalid Input. Try again", 10, 0
	newline byte 10, 0
	hexNewlineMessage byte "H", 10, 0
.code
; Prints this project title
; Modifies: edx
displayTitle proc
	mov edx, offset projectTitle
	call WriteString
	ret
displayTitle endp

; Copies elements from one array to another
copyArray proc

	mov esi, offset array2
	mov edi, offset array1

	movzx ecx, startIndex

	cmp ecx, lengthof array1
	jge lpend
	lp:
		mov al, [esi + ecx*(type byte)]
		mov [edi], al
		
		inc ecx
		inc edi

		cmp ecx, lengthof array1
		jl lp
	lpend:

	movzx ecx, startIndex
	cmp ecx, 0
	je zerolpend

	zerolp:
		mov al, 0
		mov [edi], al
		
		inc edi

		loop zerolp
	zerolpend:
	ret
copyArray endp
; Displays array contents on the console
; Modifies: esi, edi, eax
showArray proc
	mov esi, offset array1
	mov ecx, array1Length
lp:
	xor eax, eax
	mov al, byte ptr [esi]
	call WriteHex

	mov edx, offset hexNewlineMessage
	call WriteString

	inc esi

	loop lp
	ret
showArray endp
; Prints the termination message
; Modifies: edx
endProgram proc
	mov edx, offset terminationMessage
	call WriteString
	ret
endProgram endp

; Gets user input and calls other procedures
main proc
	call displayTitle

mainLoop:
	jmp firstIndexRead ; Skip printing the invalid message the first time the loop is run
	invalidIndex:
		mov edx, offset invalidMessage
		call WriteString
	firstIndexRead:
		mov edx, offset indexMessageStart
		call WriteString
		
		mov eax, lengthof array2
		dec eax
		call WriteDec

		mov edx, offset indexMessageEnd
		call WriteString
		


		call ReadInt ; eax is the returned index
		jo invalidIndex	; Check if the input was a a valid integer
		cmp eax, 5 ; eax >= 5
		jge invalidIndex
		cmp eax, 0 ; eax < 0
		jl invalidIndex

	mov startIndex, al ; Move the valid eax to startIndex
	

	call copyArray	
	call showArray
	
	jmp firstCharacterRead ; Skip printing the invalid message the first time the loop is run
	invalidCharacter:
		mov edx, offset invalidMessage
		call WriteString
	firstCharacterRead:
		mov edx, offset continueMessage
		call WriteString

		call ReadChar ; al is the returned char
		mov edx, offset newline
		call WriteString

		cmp al, 'y' 
		je mainLoop
		cmp al, 'n'
		je mainLoopEnd
		jmp invalidCharacter
mainLoopEnd:

	call endProgram
	invoke ExitProcess, 0
main endp
end main

; Why is this library not documented???
; WriteString edx:address of null-terminated string. 
; WriteDec eax: unsigned integer to print
; WriteHex eax: integer to print
; ReadInt eax:returned signed integer 
;	OV is set when input is not an integer
; ReadChar al: returned character