.section .data
    fd:
        .int 0                          # File descriptor
    testo_errore:
        .ascii "Ops! Qualcosa non ha funzionato nella lettura del file\n\n"
    testo_errore_lunghezza:
        .long .- testo_errore

.section .text
    .global read_file

.type read_file @function

read_file:
    popl %esi                           # salvo l'indirizzo della prox istruzione in ESI

    movl %eax, fd                       # Salva il file descriptor in fd (il file descriptor viene salvato di default in eax con la syscall open)
    cmpl $0, %eax
    je errore

# Utilizziamo la syscall read per leggere dati dal file aperto (fd) nel buffer.
read_loop:
    movl $3, %eax           # syscall read
    movl fd, %ebx           # file descriptor
    movl $buffer, %ecx      # Buffer di input
    movl $1, %edx           # Lunghezza massima
    int $0x80               # interruzione del kernel

    cmpl $0, %eax           # controlla se errore
    jl Endread

    cmpl $0, %eax           # controlla se EOF
    je push_last_value      # Se EOF inserisce ultimo valore

    # Controlla se ho una nuova linea
    movb buffer, %al        # copia il carattere dal buffer ad AL
    cmpb new_line_char, %al # confronta AL con il carattere "\n"  
    je check_value
    
    cmpb comma_char, %al         # confronta AL con il carattere "," 
    je check_value          # se è una "," salto per controllare se il valore in value rispetta i parametri richiesti

    cmpb cr, %al            # confronta AL con il carattere "\r"        in windows a fine di ogni riga /r/n, in Unix-like solo /n
    je readLoop             # se è a fine linea salto per incrementare il numero del prodotti

    movb %al, %bl           # trasferisci cifra ascii da AL in BL per poter usare imul
    xorl %eax, %eax         # azzera registro EAX
    movb value, %al         # copia il valore precedente

    subb $48, %bl           # converti la cifra ascii in intero                                     es "53"=>5          3
    movb $10, %dl           # metti 10 in DL per usare mul                                                                        
    mulb %dl                # moltiplica il contenuto di AL x 10  e salva in AX                     es 0*10 =0          5*10=50
    addb %al, %bl           # somma valore prec con la nuova cifra                                                      50+3=53                                                                                 
    movb %bl, value         # salva il nuovo valore in "value"
    xorl %eax, %eax         # azzera registro EAX

    jmp read_loop            # leggi nuovo char



check_value:
    cmpl $0, value_section  # Colonna 1:
    je check_more_or_equal_one

    cmpl $1, value_section  # Colonna 2:
    je check_more_or_equal_one

    cmpl $2, value_section  # Colonna 3:
    je check_more_or_equal_one
    
    cmpl $3, value_section  # Colonna 4
    je check_more_or_equal_one

    jmp Error               # Non una colonna valida


check_value_max:
    incl value_section
    cmpl $0, value_section
    je check_ID_max

    cmpl $1, value_section
    je check_durata_max

    cmpl $2, value_section
    je check_scadenza_max
    
    cmpl $3, value_section
    je check_priorita_max


check_more_or_equal_one:
    cmpl $1, value
    jge check_max 


check_less_or_equal_max_ID:
    cmpl $127, value        # incrementa contatore della riga
    incl value_section      # Vedere se è possibile metterla nel in "check_value"
    jle add_value
    jmp error

check_less_or_equal_max_durata:
    cmpl $10, value        # incrementa contatore della riga
    incl value_section      # Vedere se è possibile metterla nel in "check_value"
    jle add_value
    jmp error

check_less_or_equal_max_scadenza:
    incl value_section
    cmpl $100, value
    jle add_value
    jmp error

check_less_or_equal_max_priorità:
    movl $0, value_section  # azzera il contatore della riga
    cmpl $5, value
    jle add_value
    jmp error



errore: 
    movl $4, %eax                       # syscall write
    movl $2, %ebx                       # file descriptor (stderr)
    leal testo_errore, %ecx             # messaggio di errore
    movl testo_errore_lunghezza, %edx   # lunghezza messaggio
    int $0x80                           # interruzione del kernel

    # TODO: implementare un controllo che faccia chiudere il file dal main, tipo una variabile di controllo
