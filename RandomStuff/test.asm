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
    str1 byte "World",0
    fmt byte "Hello %s! Heres a number: %d.", 10, "This is in binary %b", 0
    crlf byte 13, 10, 0

    n dword 10

    stdout dword ?
    ;a dword 0
    stdout_buffer dword ?
    stdout_buffer_end dword ?
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
    mov bl, [edx + eax] ; Set bl to the current character
    
    cmp bl, 0 ; If current character is null, exit loop
    je break

    mov [ecx], bl ; Copy the character to std out buffer

    inc eax ; Increment the iterator
    inc ecx ; increment the std out buf ptr

    cmp ecx, stdout_buffer_end
    jl lp
    
    pusha
    call flush
    popa

    jmp lp ; loop
    
break:
    mov stdout_buffer_ptr, ecx ; Set the current std out buf ptr back to ecx

    ; mov esp, ebp ; Restore previous frame top
    ; pop ebp ; Restore previous frame bottom
    ret ; Pop the return address
puts endp

include io.inc



printf proc

    write_buf macro
        pusha
        push esp
        call puts
        add esp, 4
        popa

        mov eax, 0
    endm

    

    push ebp ; Preserve the previous frame pointer
    mov ebp, esp ; Create a new frame
    sub esp,516 ; Allocate 512 byte buffer on the stack for the output string + Allocate 4 bytes for the current parameter iterator
    
    out_str equ [ebp-512]
    parameter_iterator equ [ebp-516]

    mov edx, [ebp+8] ; Format String
    mov ecx, 0 ; Format String iterator
    mov eax, 0 ; Output String iterator

    mov ebx, 12
    mov parameter_iterator, ebx

    lp:
        mov bl, [edx+ecx]

        cmp bl, 37
        jne not_percent
                inc ecx
                mov bl, [edx+ecx]
                cmp bl, 's'
                je s_percent
                cmp bl, 'd'
                je d_percent
                cmp bl, 'u'
                je u_percent
                cmp bl, 'U'
                je up_U_percent
                cmp bl,	'x'
                je x_percent
                cmp bl, 'X'
                je up_X_percent
                cmp bl, 'f'
                je f_percent
                cmp bl, 'F'
                je up_F_percent
                cmp bl, 'e'
                je e_percent
                cmp bl, 'c'
                je c_percent
                cmp bl, 'b'
                je b_percent
                cmp bl, '%'
                je percent_percent
                jmp chk_percent_end
                    s_percent:
                            lp2:
                                ; Store the registers we are going to hijack to copy the strings.
                                push ebx
                                push ecx
                                push edx

                                mov ebx, parameter_iterator ; Get the current parameter iterator

                                mov edx, [ebp+ebx] ; Parameter String
                                add ebx, 4 ; Increment (4 bytes) the parameter iterator
                                mov parameter_iterator, ebx ; Put the current parameter iterator back into memory

                                mov ecx, 0 ; Parameter String iterator
                                ; eax is still output string indicator

                                str_cpy_lp:
                                    mov bl, [edx+ecx]
                                    inc ecx
                                    
                                    cmp bl, 0
                                    je break_str_cpy_lp

                                    mov [ebp+eax-512], bl
                                    inc eax

                                    cmp eax, 511
                                    jl str_cpy_lp
                                        pusha
                                        mov eax, ebp
                                        sub eax, 512
                                        push eax
                                        call puts
                                        add esp, 4
                                        popa
                                        mov eax, 0
                                    jmp str_cpy_lp
                                break_str_cpy_lp:

                                ; Put the original register values back.
                                pop edx
                                pop ecx
                                pop ebx
                            break2:
                        jmp chk_percent_end
                    d_percent:
                        itoa_buffer equ ebp-512-4-32 ; 2^64 has 19 digits. 32 characters should be enough :)
                        sub esp, 32
                        
                        push ebx
                        push ecx
                        push edx
                        push eax

                        
                        mov ebx, parameter_iterator ; Get the current parameter iterator

                        mov edx, [ebp+ebx] ; Parameter signed int
                        add ebx, 4 ; Increment (4 bytes) the parameter iterator
                        mov parameter_iterator, ebx ; Put the current parameter iterator back into memory
                        
                        
                        mov eax, ebp
                        sub eax, 512+4+32

                        push edx
                        push eax
                        call itoa_nocheck
                        add esp, 8

                        pop eax

                        mov edx, ebp
                        sub edx, 512+4+32

                        mov ecx, 0

                        str_cpy_lp1:
                            mov bl, [edx+ecx]
                            inc ecx
                                    
                            cmp bl, 0
                            je break_str_cpy_lp1

                            mov [ebp+eax-512], bl
                            inc eax

                            cmp eax, 511
                            jl str_cpy_lp1
                                pusha
                                mov eax, ebp
                                sub eax, 512
                                push eax
                                call puts
                                add esp, 4
                                popa
                                mov eax, 0
                            jmp str_cpy_lp1
                        break_str_cpy_lp1:

                        pop edx
                        pop ecx
                        pop ebx

                        add esp, 32
                        jmp chk_percent_end
                    up_U_percent:
                    
                        jmp chk_percent_end
                    u_percent:
                    
                        jmp chk_percent_end
                    x_percent:
                    
                        jmp chk_percent_end
                    up_X_percent:
                    
                        jmp chk_percent_end
                    f_percent:
                    
                        jmp chk_percent_end
                    up_F_percent:
                    
                        jmp chk_percent_end
                    e_percent:
                    
                        jmp chk_percent_end
                    c_percent:
                    
                        jmp chk_percent_end
                    b_percent:
                        
                        push ebx
                        push ecx
                        push edx

                        
                        mov ebx, parameter_iterator ; Get the current parameter iterator

                        mov edx, [ebp+ebx] ; Parameter unsigned int
                        add ebx, 4 ; Increment (4 bytes) the parameter iterator
                        mov parameter_iterator, ebx ; Put the current parameter iterator back into memory
                        
                        mov ecx, 80000000h
                        
                        binary_loop:
                            mov ebx, edx
                            and ebx, ecx
                            jz add_zero
                                mov ebx, '1'
                                mov [ebp+eax-512], ebx
                                jmp add_zero_end
                            add_zero:
                                mov ebx, '0'
                                mov [ebp+eax-512], ebx
                            add_zero_end:

                            shr ecx, 1
                            inc eax

                            cmp eax, 511
                            jge push_buffer
                                pusha
                                mov eax, ebp
                                sub eax, 512
                                push eax
                                call puts
                                add esp, 4
                                popa
                                mov eax, 0
                            push_buffer:

                            cmp ecx, 0
                            je break_binary_loop

                            dec ecx

                            jmp binary_loop

                        break_binary_loop:


                        pop edx
                        pop ecx
                        pop ebx
                        jmp chk_percent_end
                    percent_percent:
                        mov bl, 37
                        mov [eax+ebp-512], bl
                        inc eax
                        jmp chk_percent_end

                jmp chk_percent_end
            not_percent:
                mov [eax+ebp-512], bl
                inc eax
        chk_percent_end:
            
        inc ecx

        cmp bl, 0
        je break

        cmp eax, 511
        jl lp
            pusha
            mov eax, ebp
            sub eax, 512
            push eax
            call puts
            add esp, 4
            popa
            mov eax, 0

        jmp lp
    break:

    cmp eax,0
    je no_more
        pusha
        mov eax, ebp
        sub eax, 512
        push eax
        call puts
        add esp, 4
        popa

    no_more:
    mov esp, ebp ; Restore previous frame top
    pop ebp ; Restore previous frame bottom
    ret
    

printf endp

main proc
    push ebp
    mov ebp, esp
    sub esp, stdout_buffer_length ; Allocate 1024 bytes for the standard output buffering.
    mov stdout_buffer, esp ; Set std out buf location
    mov stdout_buffer_ptr, esp ; Set std out buf ptr to the start of the buffer
    mov eax, esp
    add eax, stdout_buffer_length
    mov stdout_buffer_end, eax

    push ebp
    mov ebp, esp

    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov stdout, eax

    push offset msg
    call puts
    pop eax

    push 1010101b
    push -10
    push offset str1
    push offset fmt
    call printf
    sub esp, 16

    jmp skip

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

skip:
    call flush

    invoke ExitProcess, 0
main endp
end main