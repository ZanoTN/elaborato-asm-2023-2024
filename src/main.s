.section .data
  filename .ascii "Ordini.txt"
  format_in .ascii "%d,%d,%d,%d\n"
  format_out .ascii "%d:%d\n"
  menu_prompt .ascii "Selezione un tipo di algoritmo: (-1 per uscire) "
  edf_prompt .ascii "Pianificazione EDF:\n"
  hpf_prompt .ascii "Pianificazione HPF:\n"
  conclusione .ascii "Conclusine: %d\n"
  penalty_msg .ascii "Penalty: %d\n"

.section .bss

  .long input_user 
  .resb prodotti 160 ;array di 10 campi ognuno da 4 interi (10*4*4)

.section .text

  .gloabal _start:

_start: 
  