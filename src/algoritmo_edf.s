.section .data  
    numero_righe: .int 0
    indice_massimo: .int 0
    indice: .int 0
    indice_secondo_livello: .int 0
    scandenza_attuale: .int 0
    scandenza_prossima: .int 0
    
.section .text
    .global algoritmo_edf
    .type algoritmo_edf, @function

algoritmo_edf:
    popl %esi  # salva l'indirizzo di ritorno da call in %esi

    # Calcola il numero di righe
    movb $4, %dl
    divb %dl
    movb %al, numero_righe

    # Inizializza gli indici
    subb $1, %al
    movb %al, indice_massimo

    movl $4, scandenza_attuale
    movl $20, scandenza_prossima  # 4 + 16

    movl $-1, indice

for_primo_livello:
    incl indice
    movl indice, %eax
    cmpl numero_righe, %eax
    je fine_for_primo_livello

    movl indice, %ebx
    movl %ebx, indice_secondo_livello

for_secondo_livello:
    incl indice_secondo_livello
    movl indice_secondo_livello, %ebx
    cmpl numero_righe, %ebx
    je fine_for_secondo_livello

    # Confronto delle scadenze
    movl scandenza_attuale, %eax
    movl scandenza_prossima, %ebx
    movl (%esp, %eax), %ecx  # scadenza attuale
    movl (%esp, %ebx), %edx  # scadenza prossima
    cmpl %ecx, %edx
    jg scambia_valori
    je check_priorita

    jmp if_primo_fine

check_priorita:
    movl scandenza_attuale, %eax
    subl $4, %eax
    movl scandenza_prossima, %ebx
    subl $4, %ebx
    movl (%esp, %eax), %ecx  # priorità attuale
    movl (%esp, %ebx), %edx  # priorità prossima
    cmpl %ecx, %edx
    jl scambia_valori

    jmp if_primo_fine

scambia_valori:
    # Scambio delle priorità
    movl scandenza_attuale, %eax
    subl $4, %eax
    movl scandenza_prossima, %ebx
    subl $4, %ebx
    movl (%esp, %eax), %ecx
    movl (%esp, %ebx), %edx
    movl %edx, (%esp, %eax)
    movl %ecx, (%esp, %ebx)

    # Scambio delle scadenze
    addl $4, %eax
    addl $4, %ebx
    movl (%esp, %eax), %ecx
    movl (%esp, %ebx), %edx
    movl %edx, (%esp, %eax)
    movl %ecx, (%esp, %ebx)

    # Scambio delle durate
    addl $4, %eax
    addl $4, %ebx
    movl (%esp, %eax), %ecx
    movl (%esp, %ebx), %edx
    movl %edx, (%esp, %eax)
    movl %ecx, (%ebx, %eax)

    # Scambio degli ID
    addl $4, %eax
    addl $4, %ebx
    movl (%esp, %eax), %ecx
    movl (%esp, %ebx), %edx
    movl %edx, (%esp, %eax)
    movl %ecx, (%esp, %ebx)

    addl $16, scandenza_prossima
    jmp for_secondo_livello

if_primo_fine:
    addl $16, scandenza_attuale
    jmp for_secondo_livello

fine_for_secondo_livello:
    addl $16, scandenza_attuale
    movl scandenza_attuale, %eax
    subl $16, %eax
    movl %eax, scandenza_attuale

    jmp for_primo_livello

fine_for_primo_livello:
    push %esi  # re-push l'indirizzo di ritorno nello stack
    ret
