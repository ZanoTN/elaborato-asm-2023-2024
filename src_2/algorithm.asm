section .bss
    extern prodotti, input_utente

section .text
    extern printf, calculate_penalty

    global algorith

algorith:
    ; Sorting algorithm based on user input
    mov eax, [input_utente]
    cmp eax, 1
    je sort_edf
    cmp eax, 2
    je sort_hpf

sort_edf:
    ; Sort by EDF (Earliest Deadline First)
    ; ... (sorting implementation)
    jmp calculate_penalty

sort_hpf:
    ; Sort by HPF (Highest Priority First)
    ; ... (sorting implementation)
    jmp calculate_penalty
