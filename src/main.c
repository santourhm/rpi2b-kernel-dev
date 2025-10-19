#include "../include/uart.h"


void main(void) {  
   
    uart_init();
    uart_putc('Q');

    while (1) {}
}