OUTPUT_FORMAT("binary")
ENTRY(_boot)

SECTIONS {
    . = 0x7C00;

    .text : {
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

    . = 0x7DFE;
    
    .sig : {
        SHORT(0xAA55)
    }

    . = 0x7E00;
}