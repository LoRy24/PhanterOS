#
# PANTHER OS by Abstract Panthers
#
# Autore: Lorenzo Rocca
# File: printing.s
#

# Codice a 16 bits
.code16

# 
# Esportazione funzioni globali
#

.global                 print_char
.global                 print_string

#
# Sezione del codice
#

.section                .text

#
# Funzione per scrivere un carattere in TTY mode. Sfrutta l'interrupt 0x10
#
# Params:
# - al: Carattere da scrivere
#
print_char:
                        movb        $0x0E, %ah                  # Sposta in ah l'intenzione di scrivere a schermo
                        int         $0x10                       # Chiama l'interrupt 0x10
                        ret                                     # Ritorna al programma chiamante

#
# Funzione per scrivere una stringa in TTY mode. Sfrutta la funzione print_char
# creata precedentemente.
#
# Params:
# - si: il puntatore all'inizio della stringa
#
print_string:
print_string.loop_begin:
                        lodsb                                   # Carica il carattere puntato da %si in %al
                        cmp         $0x00, %al                  # Comparalo a 0x00
                        jz          print_string.loop_end       # Se pari a 0x00, completa la scrittura
                        call        print_char                  # Altrimenti, scrivi il carattere in console
                        jmp         print_string.loop_begin     # Salta all'inizio del ciclo
print_string.loop_end:
                        ret                                     # Ritorna al programma chiamante
