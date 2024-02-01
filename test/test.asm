; Program: Project #1
; Author: Andrew Lin
; CMPE 102
; 9/17/23
; Write a program that calculates the following expression: total =  (num3 + num4) - (num1 + num2) + 1.

.386
.model flat,stdcall
.stack 4096



ExitProcess proto exit_code:dword
include <Irvine32.inc>
.data
	arr dword 10000010h, 20000020h, 30000040h
.code
getSum proc
	push ebp
	mov ebp, esp ; create stack frame


	mov ecx, [ebp+12]
	mov esi, [ebp+8]

	mov ebx,0
	
lp:

	mov eax, [esi]
	add bl, al
	add esi, type arr

	; dec ecx
	; jnz lp
	loop lp


	mov [ebp+8], ebx

	pop ebp ; end stack frame

	ret
getSum endp

main proc
	mov esi, offset arr
	mov ecx, lengthof arr

	push ecx
	push esi
	call getSum
	pop eax
	pop ecx

	call WriteHex


	invoke ExitProcess, 0
main endp 

end main