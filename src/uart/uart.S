
.section .text
.global uart_init
uart_init:
   
    ldr r0, =0x3F201000  
    ldr r1, =0x3F201030  
    mov r2, #0
    str r2, [r1]
    bx lr

.global uart_putc
uart_putc:
    ldr r1, =0x3F201000  
    strb r0, [r1]        
    bx lr
