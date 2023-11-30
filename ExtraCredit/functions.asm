

include <Irvine32.inc>

MONTH_SIZE = 4      ; Max number of characters for the month: 3 letters and '\0'
MONTHS = 12         ; Max number of months of the year

SalesRecord struct
    month byte MONTH_SIZE DUP(0)
    amount dword 0
SalesRecord ends


save proto near c, records:dword

.data
    totalPrefix byte "Total: $", 0
    maxPrefix byte "The highest sales amount: $", 0
    minPrefix byte "The lowest sales amount: $", 0

    monthPrompt byte "Three-character month: ", 0
    salesAmountPrefix byte "The sales amount: $", 0

    amountPrompt byte "Amount: ",0
    amountUpdateMsg byte "New amount updated", 13, 0

.code

show proc c, records:dword
    mov esi, records
    mov ecx, MONTHS
    l1:
        
        lea edx, (SalesRecord ptr [esi]).month
        call WriteString


        mov eax, 9 ; '\t' character
        call WriteChar
        mov eax, '$'
        call WriteChar
        
        mov eax, (SalesRecord ptr [esi]).amount
        call WriteDec
        call Crlf

        add esi, type SalesRecord
        loop l1
    
    call Crlf
    ret
show endp

max proc c, records:dword
    mov esi, records
    mov eax, 80000000h ; smallest negative number

    mov ecx, MONTHS
    l1:
        mov ebx, (SalesRecord ptr [esi]).amount
        cmp ebx, eax
        
        jl smaller
        mov eax, ebx
        smaller:
        

        add esi, type SalesRecord
        loop l1

    mov edx, offset maxPrefix
    call WriteString
    call WriteDec
    call Crlf
    ret
max endp

min proc c, records:dword
    mov esi, records
    mov eax, 7fffffffh ; Largest positive number

    mov ecx, MONTHS
    l1:
        mov ebx, (SalesRecord ptr [esi]).amount
        cmp ebx, eax
        
        jg greater
        mov eax, ebx
        greater:
        
        add esi, type SalesRecord
        loop l1

    mov edx, offset minPrefix
    call WriteString
    call WriteDec
    call Crlf

    ret
min endp

view proc c, records:dword
    sub esp, MONTH_SIZE ; Allocate buffer for user input

    mov edx, offset monthPrompt
    call WriteString

    lea edx, [ebp-MONTH_SIZE]
    mov ecx, MONTH_SIZE
    call ReadString
    
    mov esi, records

    mov ecx, MONTHS
    l1: 
        lea ebx, (SalesRecord ptr [esi]).month
        
        ;invoke Str_compare, edx, ebx
        push edx
        push ebx
        call Str_compare

        jne not_equal
        
        mov edx, offset salesAmountPrefix
        call WriteString
        
        mov eax, (SalesRecord ptr [esi]).amount
        call WriteDec
        call Crlf

        jmp l1_break
        not_equal:

        add esi, type SalesRecord
        loop l1
    l1_break:

    add esp, MONTH_SIZE
    ret
view endp

edit proc c, records:dword
    sub esp, MONTH_SIZE ; Allocate buffer for user input

    mov edx, offset monthPrompt
    call WriteString

    lea edx, [ebp-MONTH_SIZE]
    mov ecx, MONTH_SIZE
    call ReadString
    
    mov edx, offset amountPrompt
    call WriteString
    call ReadDec
    
    mov esi, records

    mov ecx, MONTHS
    l1: 
        lea edx, [ebp-MONTH_SIZE]
        lea ebx, (SalesRecord ptr [esi]).month
        
        push edx
        push ebx
        call Str_compare

        jne not_equal
                
        mov (SalesRecord ptr [esi]).amount, eax
        mov edx, offset amountUpdateMsg
        call WriteString

        mov esi, records
        push esi
        call save
        add esp, 4

        jmp l1_break
        not_equal:

        add esi, type SalesRecord
        loop l1
    l1_break:

    add esp, MONTH_SIZE
    ret
edit endp

total proc c, records:dword
    mov esi, records
    mov eax, 0

    mov ecx, MONTHS
    l1:
        mov ebx, (SalesRecord ptr [esi]).amount

        add eax, ebx

        add esi, type SalesRecord
        loop l1
    
    mov edx, offset totalPrefix
    call WriteString
    call WriteDec
    call Crlf
    
    ret
total endp

end



; ReadString
;   EDX points to the input buffer
;   ECX max number of non-null chars to read