; Program: Project #1
; Author: Andrew Lin
; CMPE 102
; 9/17/23
; Write a program that calculates the following expression: total =  (num3 + num4) - (num1 + num2) + 1.

.386
.model flat,stdcall
.stack 4096


ExitProcess proto exit_code:dword

.data
.code
main proc
	mov al, -129
	add al, 0

	mov al, 127
	add al, 0
	
	
	mov al, 255
	add al, 0

	invoke ExitProcess, 0
main endp 

end main