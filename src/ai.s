section .data
    filename db "Ordini.txt", 0
    format_in db "%d,%d,%d,%d", 0
    format_out db "%d:%d", 10, 0
    menu_prompt db "Selezione un tipo di algoritmo: (-1 per uscire) ", 0
    edf_prompt db "Pianificazione EDF:", 10, 0
    hpf_prompt db "Pianificazione HPF:", 10, 0
    conclusione db "Conclusine: %d", 10, 0
    penalty_msg db "Penalty: %d", 10, 0

section .bss
    prodotti resb 160 ; spazio per 10 prodotti (10 * 4 * 4 bytes)
    input_user resb 4

section .text
    extern printf, scanf, fopen, fscanf, fclose, exit
    global _start

_start:
    ; Apertura file
    push filename
    push dword [filename]
    call fopen
    add esp, 8

    test eax, eax
    jz exit_program

    mov ebx, eax ; salva il puntatore al file in ebx

    ; Lettura dei dati dal file
    mov ecx, 0 ; index
    lea edx, [prodotti]
read_loop:
    push edx
    push edx
    push edx
    push edx
    push format_in
    push ebx
    call fscanf
    add esp, 24
    inc ecx
    add edx, 16
    cmp ecx, 10
    jl read_loop

    ; Chiusura del file
    push ebx
    call fclose
    add esp, 4

    ; Chiedere all'utente quale algoritmo vuole usare
    call menu

alg_choice:
    cmp eax, 1
    je use_edf
    cmp eax, 2
    je use_hpf
    jmp alg_choice

use_edf:
    ; Chiamata all'algoritmo EDF
    push ecx
    push prodotti
    call EDF
    add esp, 8
    jmp alg_choice

use_hpf:
    ; Chiamata all'algoritmo HPF
    push ecx
    push prodotti
    call HPF
    add esp, 8
    jmp alg_choice

exit_program:
    push dword 1
    call exit

menu:
    push menu_prompt
    call printf
    add esp, 4

    push input_user
    push dword "%d"
    call scanf
    add esp, 8

    mov eax, [input_user]
    ret

EDF:
    push ebp
    mov ebp, esp
    push ebx
    push esi
    push edi

    mov ecx, [ebp + 8]
    lea ebx, [ebp + 12]
    mov esi, ebx
    add esi, ecx
    lea edi, [ebp + 20]

    ; Sorting per scadenza e priorità
edf_sort:
    cmp esi, ebx
    jle edf_done
    mov eax, [esi - 16]
    cmp eax, [esi - 32]
    jge edf_swap

    cmp eax, [esi - 32]
    je .priority
    jmp .next
.priority:
    mov eax, [esi - 12]
    cmp eax, [esi - 28]
    jle edf_swap
.next:
    sub esi, 16
    jmp edf_sort
edf_swap:
    mov eax, [esi - 16]
    mov edx, [esi - 32]
    xchg eax, edx
    mov [esi - 16], eax
    mov [esi - 32], edx
    jmp .next

edf_done:
    ; Print results and calculate penalties
    xor eax, eax
    xor edx, edx

edf_loop:
    cmp ecx, 0
    je edf_exit
    mov edi, [esi]
    push edx
    push edi
    push format_out
    call printf
    add esp, 12
    add edx, [esi + 4]
    sub edi, [esi + 8]
    jle .no_penalty
    add eax, edi
.no_penalty:
    sub ecx, 1
    add esi, 16
    jmp edf_loop
edf_exit:
    push edx
    push conclusione
    call printf
    add esp, 8
    push eax
    push penalty_msg
    call printf
    add esp, 8

    pop edi
    pop esi
    pop ebx
    pop ebp
    ret

HPF:
    push ebp
    mov ebp, esp
    push ebx
    push esi
    push edi

    mov ecx, [ebp + 8]
    lea ebx, [ebp + 12]
    mov esi, ebx
    add esi, ecx
    lea edi, [ebp + 20]

    ; Sorting per priorità e scadenza
hpf_sort:
    cmp esi, ebx
    jle hpf_done
    mov eax, [esi - 12]
    cmp eax, [esi - 28]
    jle hpf_swap

    cmp eax, [esi - 28]
    je .deadline
    jmp .next
.deadline:
    mov eax, [esi - 16]
    cmp eax, [esi - 32]
    jle hpf_swap
.next:
    sub esi, 16
    jmp hpf_sort
hpf_swap:
    mov eax, [esi - 16]
    mov edx, [esi - 32]
    xchg eax, edx
    mov [esi - 16], eax
    mov [esi - 32], edx
    jmp .next

hpf_done:
    ; Print results and calculate penalties
    xor eax, eax
    xor edx, edx

hpf_loop:
    cmp ecx, 0
    je hpf_exit
    mov edi, [esi]
    push edx
    push edi
    push format_out
    call printf
    add esp, 12
    add edx, [esi + 4]
    sub edi, [esi + 8]
    jle .no_penalty
    add eax, edi
.no_penalty:
    sub ecx, 1
    add esi, 16
    jmp hpf_loop
hpf_exit:
    push edx
    push conclusione
    call printf
    add esp, 8
    push eax
    push penalty_msg
    call printf
    add esp, 8

    pop edi
    pop esi
    pop ebx
    pop ebp
    ret
