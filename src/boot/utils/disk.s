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
# Sezione del codice
#

.section                .text

#
# Leggi N settori dal disco e caricali in memoria.
#
# Parametri:
# - ES:BX / Buffer
#
read_sectors_c0:
                        xor         %ax, %ax                    # Azzera %ax
                        mov         %ax, %ds                    # Imposta %ds a 0x0000
                        cld                                     # Azzera i flags

                        movb        $0x02, %ah                  # Intenzione di leggere settori dal disco
                        movb        $0x04, %al                  # Numero di settori da leggere
                        movb        $0x00, %ch                  # Cilindro 0
                        movb        $0x02, %cl                  # Da che settore iniziare la lettura (partono dall'1)
                        movb        $0x00, %bh                  # Testa 0

                        int         $0x13                       # Interrupt per la lettura su disco