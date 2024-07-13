section .text
    extern prodotti, printf, menu

    global calculate_penalty, penalty

calculate_penalty:
    ; Calculate penalties and print results
    ; ... (penalty calculation implementation)
    jmp menu

penalty:
    ; Penalty calculation function
    ; ... (penalty calculation code)
    ret
