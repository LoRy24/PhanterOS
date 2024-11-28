#
# PANTHER OS by Abstract Panthers
#
# Autore: Lorenzo Rocca
# File: extboot.s
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
                        .asciz      "Bootloader Esteso caricato!\n\r"

#
# Sezione del bootloader
#

.section                .bootloader

#
# Definizione funzioni globali
#

.global                 _main

#
# Entry point per l'extended bootloader
#
_main:
                        pusha                                   # Carica tutti i registri nello stack
                        mov         $welcome_message, %si       # Carica l'indirizzo della stringa in %si
                        call        print_string                # Scrivi la stringa in console
                        popa                                    # Ripristina lo stato iniziale dei registri

                        jmp         .                           # Loop infinito
