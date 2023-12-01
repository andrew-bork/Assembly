; Program: Project #4
; Author: Andrew Lin
; CMPE 102
; 12/10/23
; Write the program that displays stack addresses and 32-bit values which are pushed on the stack when the 
; procedures are called. The contents must be displayed in order from the lowest address to the highest address. The
; program should generate the similar output shown below.

.386
.model flat,stdcall
.stack 4096

include <Irvine32.inc>

ExitProcess proto exit_code:dword

; Use the following instructions along with other instructions for your program: $, CALL, PUSH, POP, TYPE, IF, ELSE, EQ, PUSHA, POPA


displayString macro msg:REQ, newline
	LOCAL msg_string
	.data
		msg_string byte msg, 0 
	.code
		pusha
		.if newline eq 0
			mov edx, offset msg_string
			call WriteString
		.else 
			mov edx, offset msg_string
			call WriteString
			call Crlf
		.endif
		popa
endm

.data
	num1 dword 1h
	num2 dword 2h
	num3 dword 3h
	num4 dword 4h
	num5 dword 5h
.code

; Show stack parameters
runLevelTwo proc
	push ebp
	mov ebp, esp

	displayString "System Parameters on Stack", 1
	displayString "------------------------------------------", 1

	mov ecx, [ebp + 8] ; number of stack addresses to print
	mov esi, [ebp] ; get base pointer of last stack frame
	lea esi, [esi+8] ; get first parameter of last stack frame

	l1: 
		displayString "Address: ", 0
		mov eax, esi
		call WriteHex
		displayString "h => Content: ", 0
		mov eax, [esi]
		call WriteHex
		displayString "h", 1

		add esi, 4 ; Advance to next parameter
		loop l1
		
	displayString "------------------------------------------", 1

	pop ebp
	ret 4 ; 1 parameter -> 4 bytes
runLevelTwo endp

runLevelOne proc
	push ebp
	mov ebp, esp

	mov eax, 5
	push eax
	call runLevelTwo
	
	pop ebp

	ret 20; 5 * 4
runLevelOne endp

main proc

	mov eax, num5
	push eax
	mov eax, num4
	push eax
	mov eax, num3
	push eax
	mov eax, num2
	push eax
	mov eax, num1
	push eax

	call runLevelOne
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