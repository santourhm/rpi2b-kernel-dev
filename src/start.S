.section .text.boot
.global _start

_start:

    mrc p15, 0, r0, c0, c0, 5  
    and r0, r0, #0x3           

    cmp r0, #0
    bne hang                   


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

