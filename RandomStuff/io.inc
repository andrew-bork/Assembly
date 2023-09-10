


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




; itoa - integer to ascii
; str:dword (pointer to a char buffer) [ebp+8]
; value:dword (integer value to covert) [ebp+12]
itoa_nocheck proc
	push ebp ; Preserve the previous frame pointer
	mov ebp, esp ; Create a new frame
	sub esp,4 ; Allocate one dword on the stack
	
	mov ecx, 0 ; Clear counter
	
	; n--
	; mov eax, [ebp+12] 
	; dec eax 
	; mov [ebp+12], eax

	mov eax, [ebp+12] ; Set eax to value

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

	cmp eax, 0	
	jne lp	; Finished converting integer. End loop and check for negative.
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
itoa_nocheck endp
