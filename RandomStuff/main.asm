; Program: Project #1
; Author: Andrew Lin
; CMPE 102
; 9/7/23
; Write a program that calculates the following expression: total =  (num3 + num4) - (num1 + num2) 

.386
.model flat,stdcall
.stack 4096

STD_OUTPUT_HANDLE equ -11
GetStdHandle proto, nStdHandle: DWORD 
; WriteConsoleA handle buf n n_written
WriteConsoleA proto, handle: DWORD, lpBuffer:PTR byte, nNumberOfBytesToWrite:DWORD, lpNumberOfBytesWritten:PTR DWORD, lpReserved:DWORD 
ExitProcess proto exit_code:dword

.data
	msg byte "Fib time", 13, 10, 0
	crlf byte 13, 10, 0

	n dword 10

	stdout dword ?
	;a dword 0
	stdout_buffer dword ?
	stdout_buffer_ptr dword ?
	stdout_buffer_length dword 1024
.code

flush proc
	mov eax, stdout_buffer_ptr ; Set eax to the std out buf ptr
	mov ebx, stdout_buffer ; Set eax to the start of std out buf

	sub eax, ebx ; calculate the current length of the buffer
	
	invoke WriteConsoleA, stdout, ebx, eax, 0, 0 ; Write buffer to stdout
	
	mov stdout_buffer_ptr, ebx ; Reset the std out buf ptr back to the start of the buffer
	ret
flush endp

puts proc
	mov edx, [esp+4] ; Set edx to the pointer to the printed string.

	; No need for locals
	; push ebp ; Preserve the previous frame pointer
	; mov ebp, esp ; Create a new frame
	
	mov eax, 0 ; Set iterator register to 0
	mov ecx, stdout_buffer_ptr ; Set ecx to the current std out buf ptr.

lp:
	mov bl, [edx + eax] ; Set ebx to the current character
	
	cmp bl, 0 ; If current character is null, exit loop
	je break

	mov [ecx], bl ; Copy the character to std out buffer

	inc eax ; Increment the iterator
	inc ecx ; increment the std out buf ptr
	
	jmp lp ; loop

break:
	mov stdout_buffer_ptr, ecx ; Set the current std out buf ptr back to ecx

	; mov esp, ebp ; Restore previous frame top
	; pop ebp ; Restore previous frame bottom
	ret ; Pop the return address
puts endp



; itoa - integer to ascii
; str:dword (pointer to a char buffer) [ebp+8]
; n:dword (size of buffer - 1) [ebp+12]
; value:dword (integer value to covert) [ebp+16]
itoa proc
	push ebp ; Preserve the previous frame pointer
	mov ebp, esp ; Create a new frame
	sub esp,4 ; Allocate one dword on the stack
	
	mov ecx, 0 ; Clear counter
	
	; n--
	; mov eax, [ebp+12] 
	; dec eax 
	; mov [ebp+12], eax

	mov eax, [ebp+16] ; Set eax to value

	; Make sure eax is the positive version.
	test eax, eax
	jns lp
	neg eax
lp: 
	mov edx, 0 ; Clear edx (For the div instruction)
	mov ebx, 10 ; Move 10 into ebx
	div ebx ; Divide edx:eax by 10.   eax is the quotient.      edx is the remainder.
	
	mov ebx, [ebp+8]
	add dl, 48 ; Convert 0-9 to ascii character '0'-'9'
	mov [ebx+ecx], dl ; set str[ecx] to the character
	inc ecx ; ecx++

	cmp ecx, [ebp+12]
	je reached_n		; Ran out of space in the string. End loop and add a null byte

	cmp eax, 0	
	je break	; Finished converting integer. End loop and check for negative.
	
	jmp lp
break:
	mov eax, [ebp+16] ; Load original value back in and test for negative
	test eax, eax
	jns reached_n
	
	; Write '-' to str[ecx] and ecx++
	mov bl, 45
	mov edx, [ebp+8]
	mov [edx+ecx], bl
	inc ecx

reached_n:
	
	; Write '\0' to str[ecx]
	mov ebx, [ebp+8]
	mov dl, 0
	mov [ebx + ecx], dl


	; Move ecx back to last character
	dec ecx
	; Init eax to the start of the string.
	mov eax, 0
lp2:
	; Reverse string.
	mov dl, [ebx+eax]
	xchg [ebx+ecx], dl
	mov [ebx+eax], dl
	
	dec ecx
	inc eax
	
	; Exit if finsihed reversing
	cmp eax, ecx
	jl lp2

	mov esp, ebp ; Restore previous frame top
	pop ebp ; Restore previous frame bottom
	ret
itoa endp

main proc
	push ebp
	mov ebp, esp
	sub esp, stdout_buffer_length ; Allocate 1024 bytes for the standard output buffering.
	mov stdout_buffer, esp ; Set std out buf location
	mov stdout_buffer_ptr, esp ; Set std out buf ptr to the start of the buffer

	push ebp
	mov ebp, esp

	invoke GetStdHandle, STD_OUTPUT_HANDLE
	mov stdout, eax

	push offset msg
	call puts
	pop eax

	sub esp, 28

	mov eax, 0
	mov [esp+8], eax
	mov eax, 1
	mov [esp+4], eax

	mov ecx, 0
	mov [esp], ecx
lp:

	mov edx, esp
	add edx, 12

	mov eax, [esp+8]

	mov eax, [esp+8]
	push eax ; value
	push 15 ; n
	push edx ; str pointer
	call itoa
	add esp, 12
	
	mov edx, esp
	add edx, 12

	push edx
	call puts
	add esp, 4

	mov eax, offset crlf
	push eax
	call puts
	add esp, 4

	
	mov eax, [esp+8]
	mov ebx, [esp+4]

	add eax, ebx
	xchg eax, ebx
	
	mov [esp+8], eax
	mov [esp+4], ebx

	mov ecx, [esp]
	inc ecx
	mov [esp], ecx
	cmp ecx, n
	jne lp

	call flush

	invoke ExitProcess, 0
main endp
end main