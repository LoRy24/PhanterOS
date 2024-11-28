OUTPUT_FORMAT("binary")
ENTRY(_main)

SECTIONS {
    . = 0x7E00;

    .text : {
        *(.bootloader)
        *(.text)
        *(.rodata)
        FILL(0x00)
    }

    .data : {
        *(.data)
        FILL(0x00)
    }

    .bss : {
        *(.bss)
        *(COMMON)
        FILL(0x00)
    }

    . = 0x85FF;

    .fillsect : {
        BYTE(0x00)
    }

    /* Fine Bootloader (4 settori) */

    .fat1 : {
        *(.fat1)
    }

    . = 0x95FF;

    .fat1_fill : {
        BYTE(0x00)
    }

    /* Fine Fat 1 - 8 Settori */

    .fat2 : {
        *(.fat1)
    }

    . = 0xA5FF;

    .fat2_fill : {
        BYTE(0x00)
    }

    /* Fine Fat 2 - 8 Settori */

    .rootdir : {
        *(.rootdir)
    }

    . = 0xADFF;

    .rootdir_fill : {
        BYTE(0x00)
    }
}