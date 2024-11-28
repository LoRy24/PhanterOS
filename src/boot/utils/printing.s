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
.global                 print_num
.global                 print_newline

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
                        push        %bx
                        call        print_char                  # Altrimenti, scrivi il carattere in console
                        pop         %bx
                        jmp         print_string.loop_begin     # Salta all'inizio del ciclo
print_string.loop_end:
                        ret                                     # Ritorna al programma chiamante

#
# Funzione per scrivere un numero in TTY mode.
#
# Params:
# - cx: numero da scrivere
#
print_num:
                        pushw       $0x00                       # Scrivi nello stack lo 0x00 per indicare il termine della lettura
print_num.conversion_start:
                        movw        $0x00, %dx                  # Azzera %dx per essere usato successivamente
                        movw        %cx, %ax                    # Sposta il numero da scrivere in %cx
                        movw        $0x0A, %bx                  # Carica il divisore 10 in %bx per ottenere la cifra meno significativa
                        divw        %bx                         # Esegui la divisione. In %dx avremo la LSC

                        addw        $0x30, %dx                  # Somma 0x30 a %dx per portarlo sui numeri
                        pushw       %dx                         # Caricalo nello stack

                        cmp         $0x00, %ax                  # Se %ax è uguale a 0, significa che abbiamo finito la lettura
                        jz          print_num.print_loop        # Inizia la scrittura a video

                        movw        %ax, %cx                    # Carica il quoziente in %cx per il nuovo loop
                        jmp         print_num.conversion_start  # Ricomincia il ciclo
print_num.print_loop:
                        pop         %dx                         # Carica il contenuto dello stack in %dx
                        mov         %dl, %al                    # Carica %dl in %al per la scrittura

                        cmp         $0x00, %dx                  # Se il valore caricato è uguale a 0x00, significa che abbiamo terminato
                        jz          print_num.end               # Termina la funzione

                        call        print_char                  # Scrivi il carattere a schermo
                        jmp         print_num.print_loop        # Riesegui la seconda routine
print_num.end:
                        ret                                     # Ritorna al programma chiamante

#
# Funzione per andare a capo
#
print_newline:
                        pusha                                   # Carica tutti i registri in memoria

                        movb        $'\n', %al                  # Carica il carattere newline in al
                        call        print_char                  # Scrivilo
                        movb        $'\r', %al                  # Carica il carattere per resettare la riga in al
                        call        print_char                  # /

                        popa                                    # Ripristina tutti i registri
                        ret                                     # Ritorna al programma chiamante
