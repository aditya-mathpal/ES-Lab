#include<stdio.h>
#include<windows.h>

unsigned int i, j, sw2, num;

void delay() {
    printf("%x\n", num);
    Sleep(700);
}

int main() {
    //LPC_PINCON->PINSEL0 = LPC_PINCON->PINSEL1 = 0;
    //LPC_GPIO0->FIODIR |= 0xFF<<4; // Set P0.4 to P0.11 as output
    //LPC_GPIO1->FIODIR &= ~(0x1<<26); // Set P1.26 as input

    while(1) {
        //sw2 = (LPC_GPIO1->FIOPIN & (1<<26)) ? 0 : 1; // Read P1.26
        // if(!sw2) {
        //     LPC_GPIO0->FIOCLR = 0xFF<<4; // Clear P0.4 to P0.11
        // } else {
            num = 0xFF<<4; // Set P0.4 to P0.11
            delay();
            for(i = 0; i < 3; i++) {
                num &= ~(1<<(4+i) | 1<<(11-i));
                delay();
            }
            for(i = 0; i < 4; i++) {
                num |= 1<<(7-i) | 1<<(8+i);
                delay();
            }
        //}
    }
    return 0;
}