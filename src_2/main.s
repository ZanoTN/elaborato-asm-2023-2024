.section .data

    fd: .int 0      # File descriptor
    argc: .int 0      # per salvare il numero di argomenti
    numero_elementi: .int 0
    
    testo_errore: .ascii "Ops! Qualcosa non ha funzionato\n\n"
    testo_errore_lunghezza: .long .- testo_errore
    
    testo_menu: .ascii "Seleziona l'algoritmo da utilizzare (EDF: 1, HPF: 2, esci: 0): "
    testo_menu_lunghezza: .long .- testo_menu

    testo_selezione_non_valida: .ascii "Selezione non valida\n"
    testo_selezione_non_valida_lunghezza: .long .- testo_selezione_non_valida

    carattere_nuova_linea: .ascii "\n"

    carattere_selettore_algoritmo_EDF: .ascii "1"
    carattere_selettore_algoritmo_HPF: .ascii "2"
    carattere_selettore_esci: .ascii "0"

    input_utente: .ascii "0"

.section .text
    .global _start

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
    movl $0, %ecx
    int $0x80   

    # Verifichiamo se il file è stato aperto o no
    cmp $0, %eax
    jl errore

    movl %eax, fd
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
    movl numero_elementi, %eax
scarica_pila:    
    cmpl $0, %eax
    je esci
    popl %ebx
    decl %eax
    jmp scarica_pila 


menu:
    # Stampo il testo del menu
    movl $4, %eax 
    movl $1, %ebx
    leal testo_menu, %ecx
    movl testo_menu_lunghezza, %edx
    int $0x80

    # Scanf dell'input
    xorl %ecx, %ecx
    movl $3, %eax
    movl $0, %ebx
    leal input_utente, %ecx
    movl $1, %edx
    int $0x80


    movb carattere_selettore_algoritmo_EDF, %al
    movb carattere_selettore_algoritmo_HPF, %bl
    movb carattere_selettore_esci, %cl
    movb input_utente, %dl
    
    cmpb %al, %dl
    je algoritmo_EDF

    cmpb %bl, %dl
    je algoritmo_HPF

    cmpb %cl, %dl
    je esci

    # Stampo il testo di errore
    movl $4, %eax
    movl $1, %ebx
    leal testo_selezione_non_valida, %ecx
    movl testo_selezione_non_valida_lunghezza, %edx
    int $0x80

    jmp menu
     
algoritmo_EDF:
    # Chiamo la funzione di ordinamento EDF
    call algoritmo_EDF
    call programmazione

    # Stampo una nuova linea
    movl $4, %eax
    movl $1, %ebx
    leal carattere_nuova_linea, %ecx
    movl $1, %edx
    int $0x80

    jmp menu

algoritmo_HPF:
    # Chiamo la funzione di ordinamento HPF
    call algoritmo_HPF
    call programmazione

    # Stampo una nuova linea
    movl $4, %eax
    movl $1, %ebx
    leal carattere_nuova_linea, %ecx
    movl $1, %edx
    int $0x80

    jmp menu


esci:
    movl $1, %eax
    xorl %eax, %eax
    int $0x80
