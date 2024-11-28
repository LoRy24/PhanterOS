#
# PANTHER OS by Abstract Panthers
#
# Autore: Lorenzo Rocca
# File: disk.s
#

# Codice a 16 bits
.code16

# 
# Esportazione funzioni globali
#

.global                 read_sectors_c0

#
# Sezione dei dati
#

.section                .rodata

#
# Messaggio di lettura con successo
#
read_success_message:
                        .asciz      " settori letti con successo!\n\r"

#
# Messaggio di errore
#
read_error_message:
                        .asciz      "Errore durante la lettura! Errore: "

#
# Sezione del codice
#

.section                .text

#
# Leggi N settori dal disco e caricali in memoria.
#
# Parametri:
# - %al / Settori da leggere
# - %cl / Settore da cui iniziare la lettura
# - %es:%bx / Buffer
#
read_sectors_c0:
read_sectors_c0.start:
                        #
                        # Leggi dalla memoria i settori
                        #
                        movb        $0x02, %ah                  # Intenzione di leggere settori dal disco
                        movb        $0x00, %ch                  # Cilindro 0
                        movw        $0x0000, %dx                # Azzera %dx

                        int         $0x13                       # Interrupt per la lettura su disco

                        cmp         $0x00, %ah                  # Compara %ah a 0x00
                        jz          read_sectors_c0.success     # Se %ah = 0, salta a success

                        #
                        # Scrivi il messaggio di errore
                        #
                        mov         $read_error_message, %si    # Carica l'indirizzo della stringa in %si
                        call        print_string                # Scrivi la stringa in console

                        xor         %cx, %cx                    # Azzera %cx
                        mov         %ah, %cl                    # Sposta %ah in %cl per la scrittura
                        call        print_num                   # Scrivi l'errore

                        call        print_newline               # Vai a capo

                        jmp         read_sectors_c0.end         # Salta alla fine della funzione
read_sectors_c0.success:
                        #
                        # Scrivi il numero di settori letti
                        #
                        xor         %cx, %cx                    # Azzera %cx
                        mov         %al, %cl                    # Sposta %al in %cl per la scrittura (registri letti)
                        call        print_num                   # Scrivi il numero di registri letti

                        mov         $read_success_message, %si  # Carica l'indirizzo della stringa in %si
                        call        print_string                # Scrivi la stringa in console
read_sectors_c0.end:
                        ret                                     # Restituisci il controllo al programma chiamante
