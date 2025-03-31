#include<LPC17xx.h>

unsigned int i, j, sw2;

void delay() {
    for(j = 0; j < 3000; j++);
}

int main() {
    LPC_PINCON->PINSEL0 = LPC_PINCON->PINSEL1 = 0;
    LPC_GPIO0->FIODIR |= 0xFF<<4; // Set P0.4 to P0.11 as output
    LPC_GPIO1->FIODIR &= ~(0x1<<26); // Set P1.26 as input

    while(1) {
        sw2 = (LPC_GPIO1->FIOPIN & (1<<26)) ? 0 : 1; // Read P1.26
        if(!sw2) {
            LPC_GPIO0->FIOCLR = 0xFF<<4; // Clear P0.4 to P0.11
        } else {
            LPC_GPIO0->FIOSET = 0xFF<<4; // Set P0.4 to P0.11
            delay();
            for(i = 0; i < 3; i++) { // 3 because initial state has manually been set
                LPC_GPIO0->FIOCLR = 1<<(4+i) | 1<<(11-i);
                delay();
            }
            for(i = 0; i < 4; i++) {
                LPC_GPIO0->FIOSET = 1<<(7-i) | 1<<(8+i);
                delay();
            }
        }
    }
    return 0;
}