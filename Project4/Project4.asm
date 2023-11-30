; Program: Project #3
; Author: Andrew Lin
; CMPE 102
; 11/11/23
; Write a program that controls the laser system at a medical devices company.
; The program includes a main procedure which gets user inputs and uses the
; input values for the OK button press, CANCEL button press, the SET button press,
; the CLEAR button press, and other functionalities on the touch screen.


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

runLevelTwo proc
	push ebp
	mov ebp, esp

	displayString "System Parameters on Stack", 1
	displayString "------------------------------------------", 1

	mov ecx, [ebp + 8] ; number of stack addresses to print
	lea esi, [ebp + 12] ; ebp + ret addr + 1 parameter -> 12

	l1: 
		displayString "Address: ", 0
		mov eax, esi
		call WriteHex
		displayString "h => Content: ", 0
		mov eax, [esi]
		call WriteHex
		displayString "h", 1

		add esi, 4
		loop l1
		
	displayString "------------------------------------------", 1

	pop ebp
	ret 4 ; 1 parameter -> 4 bytes
runLevelTwo endp

runLevelOne proc
	push ebp
	mov ebp, esp

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

	mov eax, 5
	push eax
	call runLevelTwo
	
	add esp, 20 ; 5 * 4
	pop ebp

	ret ; no parameters
runLevelOne endp

main proc
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