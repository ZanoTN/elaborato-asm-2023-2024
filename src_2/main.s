section .data

    fd:
        .int 0      # File descriptor
    argc:
        .int 0      # per salvare il numero di argomenti
    numero_elementi: 
        .int 0
    testo_errore:
        .ascii "Ops! Qualcosa non ha funzionato\n\n"
    testo_errore_lunghezza:
        .long .- testo_errore

section .text
    global _start

_start:
    popl %esi
    movl argc, %esi

    cmpl $2, %esi             # Controllo se ci sono due argomenti nel argv ("main", "[nome file]")
    jne errore

    popl %esi               # Togliamo il primo elemento, cioè il nome del programma ("main")

    popl %esi
    cmpl $0, %esi           # Confronto se esiste un valore (nome del file)
    jz errore

    # Apriamo il file
    movl $5, %eax
    movl %esi, %ebx
    movl %0, %ecx
    int $0x80   

    # Verifichiamo se il file è stato aperto o no
    cmp $0, %eax
    jl Error

    movl %eax 
    call read_file
    movb %al, numero_elementi # TODO: Da verficare

errore:
    movl $4, %eax
    movl $2, %ebx # stderr
    leal testo_errore, %ecx
    movl testo_errore_lunghezza, %edx
    int $0x80
    jmp pre_scarica_pila

pre_scarica_pila:
    movl numelem, %eax
scarica_pila:    
    cmpl $0, %eax
    je esci
    popl %ebx
    decl %eax
    jmp scarica_pila 

esci:
    movl $1, %eax
    xorl %eax, %eax
    int $0x80
