#
# PANTHER OS by Abstract Panthers
#
# Autore: Lorenzo Rocca
# File: boot.s
#

# Codice a 16 bits
.code16

#
# Sezione delle costanti
#

.section                .rodata

#
# Messaggio di benvenuto
#
welcome_message:
                        .asciz      "Benvenuto in PantherOS!\n\rBy Lorenzo Rocca\n\r"

#
# Sezione del codice
#

.section                .text

#
# Entry point del boot
#
_boot:
                        pusha                                   # Carica tutti i registri nello stack
                        mov         $welcome_message, %si       # Carica l'indirizzo della stringa in %si
                        call        print_string                # Scrivi la stringa in console
                        popa                                    # Ripristina lo stato iniziale dei registri

                        pusha                                   # Carica tutti i registri nello stack
                        mov         $0x0A, %cx                  # Carica il numero $0x0A in %cx
                        call        print_num                   # Visualizza il numero a schermo
                        popa                                    # Ripristina lo stato iniziale dei registri

                        jmp         .                           # Resta all'indirizzo di memoria attuale
