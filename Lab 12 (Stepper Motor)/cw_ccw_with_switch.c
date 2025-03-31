#include <LPC17xx.h>

void clock_wise(void);
void anti_clock_wise(void);

unsigned long int var1;
unsigned int i, k;
unsigned int sw2;

int main(void)
{
    SystemInit();
    SystemCoreClockUpdate();
    
    // Configure pins
    LPC_PINCON->PINSEL0 = 0xFFFF00FF; // P0.4 to P0.7 GPIO for stepper motor
    LPC_GPIO0->FIODIR = 0x000000F0;   // P0.4 to P0.7 output
    
    // SW2 setup - assuming SW2 is connected to P0.21 as in the reference code
    LPC_GPIO0->FIODIR &= ~(1<<21);    // Set P0.21 as input for SW2
    
    while (1)
    {
        // Read SW2 state
        sw2 = LPC_GPIO0->FIOPIN & (1<<21);
        
        // Decide rotation direction based on SW2
        if (sw2) {
            // SW2 is high, rotate clockwise
            clock_wise();
        } else {
            // SW2 is low, rotate counterclockwise
            anti_clock_wise();
        }
    }
}

void clock_wise(void)
{
    var1 = 0x00000008; // Initial value (just below P0.4)
    for (i = 0; i <= 3; i++) // for A B C D Stepping
    {
        var1 = var1 << 1; // Shift left to move through pins P0.4-P0.7
        LPC_GPIO0->FIOPIN = var1;
        for (k = 0; k < 3000; k++); // Delay for step speed variation
    }
}

void anti_clock_wise(void)
{
    var1 = 0x00000100; // Initial value (just above P0.7)
    for (i = 0; i <= 3; i++) // for A B C D Stepping
    {
        var1 = var1 >> 1; // Shift right to move through pins P0.7-P0.4
        LPC_GPIO0->FIOPIN = var1;
        for (k = 0; k < 3000; k++); // Delay for step speed variation
    }
}
