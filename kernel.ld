ENTRY(_start)

SECTIONS
{
    . = 0x0000;

    .text : {
        KEEP(*(.text.boot))
        *(.text)
    }

    .data : {
        *(.data)
    }

    .bss : {
        __bss_start = .;  /* Define a symbol for the start of .bss */
        *(.bss)
        __bss_end = .;    /* Define a symbol for the end of .bss */
    }
}