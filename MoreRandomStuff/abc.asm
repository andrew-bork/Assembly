; Program: Project #1
; Author: Andrew Lin
; CMPE 102
; 9/7/23
; Write a program that calculates the following expression: total =  (num3 + num4) - (num1 + num2) 

.386
.model flat,stdcall
.stack 4096


ExitProcess proto exit_code:dword

.data
	a word 1020h, 3040h, 5060h
.code
main proc
	
	mov edi, offset a

	mov ax, [edi]
	xchg al, ah
	mov [edi], ax
	add edi, type a
	
	mov ax, [edi]
	xchg al, ah
	mov [edi], ax
	add edi, type a
	
	mov ax, [edi]
	xchg al, ah
	mov [edi], ax
	add edi, type a






	invoke ExitProcess, 0
main endp
end main