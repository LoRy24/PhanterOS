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
# Offset del codice (compilatore)
#
.org                    $0x7c00

#
# Salta oltre il filesystem (0x03 bytes)
#
_boot:
                        jmp         _boot_program               # Salta al codice eseguibile del boot loader (2 byte)
                        nop                                     # Riempi l'ultimo byte

#
# Definizione del FileSystem FAT 16
#
fat_16_table:
                        .ascii      "PHANTOS "                  # Nome OEM (lo personalizzo perchè si)
                        .word       0x0200                      # Numero di bytes per settore (512)
                        .byte       0x01                        # Settori ogni cluster
                        .word       0x0001                      # Settori riservati, in questo caso solo il boot-sector
                        .byte       0x02                        # Numero di tabelle FAT
                        .word       0x0040                      # Numero di voci dei files massime
                        .word       0x0800                      # Totale dei settori: 2048 (1MB)
                        .byte       0xF0                        # Media Descriptor - Floppy Disk 0xF0
                        .word       0x0008                      # Settori per FAT (8 = 1MB di Cluster)
                        .word       0x0012                      # Settori per traccia (18)
                        .word       0x0002                      # Numero testine
                        .long       0x00000000                  # Settori nascosti
                        .long       0x00000800                  # Numero totale di settori
                        .byte       0x00                        # Numero drive
                        .byte       0x00                        # Flag riservato
                        .byte       0x28                        # Firma
                        .long       0x00000000                  # ID volume
                        .ascii      "PHANTEROSv1"               # Label del volume
                        .ascii      "FAT16   "                  # Tipo di Filesystem

#
# Entry point del boot
#
_boot_program:
                        pusha                                   # Carica tutti i registri nello stack
                        mov         $welcome_message, %si       # Carica l'indirizzo della stringa in %si
                        call        print_string                # Scrivi la stringa in console
                        popa                                    # Ripristina lo stato iniziale dei registri

                        pusha                                   # Carica tutti i registri nello stack
                        mov         $0x0A, %cx                  # Carica il numero $0x0A in %cx
                        call        print_num                   # Visualizza il numero a schermo
                        popa                                    # Ripristina lo stato iniziale dei registri

                        jmp         .                           # Resta all'indirizzo di memoria attuale
