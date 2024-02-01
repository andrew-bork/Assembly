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
	array sword 1000h, 2000h, 3000h, 4000h
	
	num1 word 1
	num2 word 2
	num3 word 4
	num4 word 8

	total word ?
.code
main proc

	mov esi, offset array
	
	; Add each array element value to each data label and store its sum in that variable.
	mov ax, [esi] ; Store array index "0" into ax
	add num1, ax ; Add ax to num1 and store in num1
	add esi, type array ; Advance the iterator by the size of the data.
	
	mov ax, [esi] ; Store array index "1" into ax
	add num2, ax ; Add ax to num2 and store in num2
	add esi, type array ; Advance the iterator by the size of the data.
	
	mov ax, [esi] ; array[2]
	add num3, ax 
	add esi, type array
	
	mov ax, [esi] ; array[3]
	add num4, ax

	; Write a program that calculates the following expression: total =  (num3 + num4) - (num1 + num2) 
	mov bx, num3 ; Start with +num3
	mov ax, num4 ; Store num4 in bx
	add bx, ax ; Add bx (num4) to ax (num3)
	mov ax, num1 ; Store num1 in bx
	sub bx, ax ; Subtract bx (num1) from ax (num3 + num4)
	mov ax, num2 ; Store num2 in bx
	sub bx, ax ; Substract bx (num2) from ax (num3 + num4 - num1)
	inc bx ; Add 1 to ax (num3 + num4 - num1 - num2)
	mov total, bx ; Store the result of ax (num3 + num4 - num1 - num2 + 1) into total.


	invoke ExitProcess, 0
main endp 

end main