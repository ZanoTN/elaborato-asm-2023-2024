section .data
    filename        db 15                                                       ; Space for filename, 15 bytes
                    db 0                                                        ; Null terminator
    prodotti        times 160 db 0                                              ; Space for 10 prodotto structs (each 16 bytes), initialized to 0
    fmt_error       db "Nome file non specificato", 10, 0                       ; Error message string, newline (10), null terminator (0)
    fmt_menu        db "Selezione un tipo di algoritmo: (-1 per uscire): ", 0   ; Menu prompt string
    fmt_read        db "%d,%d,%d,%d", 0                                         ; Format string for reading integers

section .bss
    file            resq 1          ; File handle
    input_utente    resb 4          ; Space for user input

section .text
    extern fopen, fclose, printf, scanf, read_file, menu

    global _start

_start:
    ; Check if a filename is provided
    mov rdi, [rsp+8]         ; Get the filename from command-line arguments
    test rdi, rdi
    jz error_no_file

    ; Copy the filename to the buffer
    mov rsi, filename
    mov rcx, 15
    rep movsb

    ; Open the file
    mov rdi, filename
    mov rsi, 0               ; Read-only
    call fopen
    mov [file], rax

    ; Check if the file was opened
    test rax, rax
    jz error_no_file

    ; Read the file line by line
    mov rdi, [file]
    mov rsi, prodotti
    call read_file

    ; Close the file
    mov rdi, [file]
    call fclose

    ; Proceed to menu
    call menu

error_no_file:
    mov rdi, fmt_error
    call printf
    call exit

exit:
    mov rax, 60        ; syscall: exit
    xor rdi, rdi       ; exit code 0
    syscall
