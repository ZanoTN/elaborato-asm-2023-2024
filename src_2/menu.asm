section .data
    fmt_menu db "Selezione un tipo di algoritmo: (-1 per uscire): ", 0

section .bss
    extern prodotti, input_utente

section .text
    extern printf, scanf, algorith, exit

    global menu

menu:
    mov rdi, fmt_menu
    call printf
    call scanf
    mov [input_utente], eax

    ; Handle the input
    cmp eax, 1
    je algorith
    cmp eax, 2
    je algorith
    cmp eax, -1
    je exit

    jmp menu
