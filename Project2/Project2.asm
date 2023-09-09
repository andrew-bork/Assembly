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
	array word 1000h, 2000h, 3000h, 4000h
	
	num1 word 1
	num2 word 2
	num3 word 4
	num4 word 8

	total word ?
.code
main proc
	
	; Add each array element value to each data label and store its sum in that variable.
	mov ax, array + 0 ; Store array index "0" into ax
	mov bx, num1 ; Store num1 into bx
	add bx, ax ; Add bx (num1) to ax (array[0]) and store in bx
	mov num1, bx ; Store bx back into num1
	
	
	mov ax, array + 2 * 1 ; Store array index "1" into ax  (Each array index is 2 bytes, thus 2 * 1 to access index 1)
	mov bx, num2 ; Store num2 into bx
	add bx, ax ; Add bx (num2) to ax (array[1]) and store in in bx
	mov num2, bx ; Store bx back into num2
	

	; And so on with array[2] and array[3] and num3 and num4
	mov ax, array + 2 * 2
	mov bx, num3
	add bx, ax
	mov num3, bx
	
	mov ax, array + 2 * 3
	mov bx, num4
	add bx, ax
	mov num4, bx

	; Write a program that calculates the following expression: total =  (num3 + num4) - (num1 + num2) 
	mov ax, num3 ; Start with +num3
	mov bx, num4 ; Store num4 in bx
	add ax, bx ; Add bx (num4) to ax (num3)
	mov bx, num1 ; Store num1 in bx
	sub ax, bx ; Subtract bx (num1) from ax (num3 + num4)
	mov bx, num2 ; Store num2 in bx
	sub ax, bx ; Substract bx (num2) from ax (num3 + num4 - num1)
	inc ax ; Add 1 to ax (num3 + num4 - num1 - num2)
	mov total, ax ; Store the result of ax (num3 + num4 - num1 - num2 + 1) into total.


	invoke ExitProcess, 0
main endp
end main