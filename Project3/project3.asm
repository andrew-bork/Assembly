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

; Use the following instructions along with other instructions for your program: CMP, JZ, SHL, RCL, RCR, and OR.

.data
	; Set the MSB (most significant bit) of the control byte to confirm the laser is in the standby mode.
	; Set the LSB (least significant bit) of the control byte to confirm the laser is in the ready mode.
	; Make sure other bits (bit 2 to bit 6) are cleared.
	controlVariable byte 0

	; Strings

	titleString byte "Medical Laser System", 13, 10, 13, 10, 0
	startSelectString byte "Start? y/n: ", 0 
	readySelectString byte "Ready? y/n: ", 0
	standbyBitSelectString byte "Standby bit (1/0): ", 0
	readyBitSelectString byte "Ready bit (1/0): ", 0
	fireSelectString byte "Fire? y/n: ", 0
	unableToFireString byte "Unable to fire", 13, 10, 0
	firedString byte "System fired", 13, 10, 0
	standbyString byte "System standby", 13, 10, 0
	readyString byte "System ready", 13, 10, 0
	invalidInputString byte "Invalid Input", 13, 10, 0
	shutdownString byte "System shutdown", 13, 10, 13, 10, 0

.code


; Asks user a y/n question. Only accepts valid characters: y,n
; Move prompt string address on to stack
; Sets al to 0 when user enters 'n'. al is not 0 when user enters 'y'
; Modifies: eax, edx
ask_yes_no_question proc
	push ebp ; Init stack frame
	mov ebp, esp


	jmp first_loop
	invalid_input:
		; Let user know input was invalid
		mov edx, offset invalidInputString
		call WriteString
	first_loop:
		; Print prompt
		mov edx, [ebp+8]
		call WriteString

		; Read character
		call ReadChar
		; Print that character
		call WriteChar
		; Print new line
		call Crlf

		; Break if user entered either 'y' or 'n'
		cmp al, 'y'
		je return
		cmp al, 'n'
		je return

		; Input was invalid
		jmp invalid_input
	return:
		pop ebp ; Destroy stack frame

		sub al, 'n' ; al is zero when 'n' is entered.
		ret

ask_yes_no_question endp

; Asks user for 1 or 0. Only accepts valid characters: 1, 0
; Move prompt string address on to stack
; Sets al to 0 when user enters '0'. al is not 0 when user enters '1'
; Modifies: eax, edx
ask_bit proc
	push ebp ; Init stack frame
	mov ebp, esp


	jmp first_loop
	invalid_input:
		; Let user know input was invalid
		mov edx, offset invalidInputString
		call WriteString
	first_loop:
		; Print prompt
		mov edx, [ebp+8]
		call WriteString

		; Read character
		call ReadChar
		; Print that character
		call WriteChar
		; Print new line
		call Crlf
		
		; Break if user entered either '1' or '0'
		cmp al, '1'
		je return
		cmp al, '0'
		je return

		; Input was invalid
		jmp invalid_input
	return:
		pop  ; Destroy stack frame

		sub al, '0' ; al is zero when '0' is entered. al is 1 when '1' is entered
		ret

ask_bit endp



; Gets user input and calls other procedures
main proc
	mov edx, offset titleString
	call WriteString

	start_mode:
		; Ask if user would like to start machine
		mov edx, offset startSelectString
		push edx
		call ask_yes_no_question
		add esp, 4

		; User answered "n"
		cmp al, 0
		jz shutdown_mode

		; Enters check_mode automatically
		; jmp check_mode

	check_mode:
		
		; Check which mode we are in.
		movzx eax, controlVariable
		test eax, 80h ; 0b10000000 test msb (standby mode)
		jz standby_mode ; Enter if not in standby
		test eax, 01h ; 0b00000001 test lsb (ready mode)
		jz ready_mode ; Enter if not ready

		; automatically enters fire mode if both bits are set

	fire_mode:

		; Ask user whether to fire or not
		mov edx, offset fireSelectString
		push edx
		call ask_yes_no_question
		add esp, 4

		cmp al, 0 ; al is 0 when user enters 'n'
		je cancel_fire

		should_fire:
			; Check if the laser if ready
			mov bl, controlVariable
			test bl, 01h
			jz not_ready

			; If ready, fire laser
			mov edx, offset firedString
			call WriteString

			; Recheck mode
			jmp check_mode

			not_ready: 
				; Let user know laser is not ready
				mov edx, offset unableToFireString
				call WriteString

				; Recheck mode
				jmp check_mode
			
		cancel_fire:
			; Reset everything (for some reason)
			call Crlf

			; Reset control variable
			shl al, 8
			mov controlVariable, al
			
			; Go back to the start
			jmp start_mode

	standby_mode:
		; Print standby string
		mov edx, offset standbyString
		call WriteString

		; Ask user for standby bit
		mov edx, offset standbyBitSelectString
		push edx
		call ask_bit
		add esp, 4
			
		; Save the bit for later
		push eax ; Push the selected bit onto stack
			
		; Ask user to confirm
		mov edx, offset readySelectString
		push edx
		call ask_yes_no_question
		add esp, 4

		; Only select bit when user enters 'y'
		cmp eax, 0
		je check_mode ; skip bit set if user cancels (entered 'n')

		pop eax ; Pop the selected bit from the stack
		rcr al,2 ; 0b00000001 -> 0b10000000, 0b00000000 -> 0b00000000
		mov bl, controlVariable
		or bl, al ; set the bit
		mov controlVariable, bl

		; return to check_mode
		jmp check_mode
	ready_mode:
		; Print ready string
		mov edx, offset readyString
		call WriteString

		; Ask user for ready bit
		mov edx, offset readyBitSelectString
		push edx
		call ask_bit
		add esp, 4
			
		; Set the bit
		mov bl, controlVariable
		rcl al, 9 ; NOP
		or bl, al
		mov controlVariable, bl

		; Enter fire mode
		jmp fire_mode

	shutdown_mode:

	; Print shutdown string
	mov edx, offset shutdownString
	call WriteString
	

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