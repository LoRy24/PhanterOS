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
}