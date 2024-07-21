.section .data  
    numero_righe: .int 0
    indice_massimo: .int 0
    indice: .int 0
    indice_secondo_livello: .int 0

    priorita_attuale: .int 0
    priorita_prossima: .int 0

.section .text
    .global algoritmo_hpf
    .type algoritmo_hpf @function

algoritmo_hpf:
    popl %esi

    movb $4, %dl
    divb %dl
    movb %al, numero_righe

    # Inizializziamo gli indici
    subb $1, %al            # Indice massimo e non la lunghezza massima
    movb %al, indice_massimo

    movl $-1, indice            # Settiamo l'indice


for_primo_livello:
    incl indice
    movl indice, %eax

    cmpl %eax, indice_massimo
    je fine_for_primo_livello           # Controlliamo di non essere alla fine del primo for

    
    movl $20, priorita_prossima        # 4 + 16

    movl indice, %ebx
    movl %ebx, indice_secondo_livello
    decl indice_secondo_livello                     # Potrebbe essere inutile, ma per ora lo teniamo

for_secondo_livello:
    incl indice_secondo_livello
    movl indice_secondo_livello, %ebx

    cmpl %ebx, indice_massimo
    je for_primo_livello

if_primo:                      # Confrontiamo la scandenza attuale con quella successiva 
    movl priorita_attuale, %eax
    movl priorita_prossima, %ebx

    movl (%esp, %eax), %ecx         # valore scadenza attuale
    movl (%esp, %ebx), %edx         # valore scadenza prossima

    cmpl %ecx, %edx
    jl scambia_valori

    cmpl %ecx, %edx
    je check_scadenza

    jmp if_primo_fine


if_primo_fine: 
    incl indice_secondo_livello
    addl $16, priorita_attuale
    addl $16, priorita_prossima
    jmp for_primo_livello



check_scadenza: 
    movl priorita_attuale, %eax
    subl $4, %eax                       # Vado a prendere la priorità 
    movl priorita_prossima, %ebx
    subl $4, %ebx
    movl (%esp, %eax), %ecx             # priorita piu in alto nella pila
    movl (%esp, %ebx), %edx             # priorita piu in basso nella pila

    cmpl %ecx, %edx
    jg scambia_valori

    jmp if_primo_fine


scambia_valori: 
    movl priorita_attuale, %eax
    movl priorita_prossima, %ebx

    # Scambia priorità
    movl (%esp, %eax), %ecx
    movl (%esp, %ebx), %edx
    movl %edx, (%esp, %eax)
    movl %ecx, (%esp, %ebx)

    # Scambia scadenza
    addl $4, %eax
    addl $4, %ebx
    movl (%esp, %eax), %ecx
    movl (%esp, %ebx), %edx
    movl %edx, (%esp, %eax)
    movl %ecx, (%esp, %ebx)

    # Scambia durata
    addl $4, %eax
    addl $4, %ebx
    movl (%esp, %eax), %ecx
    movl (%esp, %ebx), %edx
    movl %edx, (%esp, %eax)
    movl %ecx, (%esp, %ebx)

    # Scambia ID
    addl $4, %eax
    addl $4, %ebx
    movl (%esp, %eax), %ecx
    movl (%esp, %ebx), %edx
    movl %edx, (%esp, %eax)
    movl %ecx, (%esp, %ebx)

    jmp for_primo_livello


fine_for_primo_livello:
    push %esi           # repusha indirizzo prox operazione nello stack
    ret

