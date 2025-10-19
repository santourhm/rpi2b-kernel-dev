.section .text.boot
.global _start

_start:

    ldr sp, =0x800000

    ldr r0, =__bss_start
    ldr r1, =__bss_end
    mov r2, #0

bss_loop:
    cmp r0, r1
    bge bss_loop_end
    str r2, [r0], #4
    b bss_loop
bss_loop_end:

    bl main

hang:
    wfe
    b hang
