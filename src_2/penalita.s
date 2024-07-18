.section .data
    numero_righe: .int 0
    indice_massimo: .int 0
    indice: .int 0

    durata: .int 0

    priorita_attuale: .int 0

.section .text
    .global penalita
    .type penalita @function

penalita:
    popl %esi

    movb $4, %dl
    divb %dl
    movb %al, numero_righe

    # Inizializziamo gli indici
    subb $1, %al            # Indice massimo e non la lunghezza massima
    movb %al, indice_massimo

    xorl %edx, %edx
    movl %edx, durata

    movl $4, priorita_attuale

    movl $-1, indice            # Settiamo l'indice

for:
    incl indice
    movl indice, %eax

    cmpl %eax, indice_massimo
    je fine_for


    


fine_for:

