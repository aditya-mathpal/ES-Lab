#include <LPC17xx.h>

#define PWM_PERIOD 30000

unsigned char SCAN_CODE[4] = {0x11, 0x21, 0x41, 0x81};
unsigned int intensityLevels[4] = {3000, 7500, 15000, 22500};

void initPWM(void) {
    LPC_PINCON->PINSEL3 |= (2 << 14);
    LPC_PWM1->PCR = (1 << 12);
    LPC_PWM1->PR = 0;
    LPC_PWM1->MR0 = PWM_PERIOD;
    LPC_PWM1->MCR = (1 << 1);
    LPC_PWM1->LER = (1 << 0);
    LPC_PWM1->TCR = (1 << 0) | (1 << 3);
}

void updatePulseWidth(unsigned int pulseWidth) {
    LPC_PWM1->MR4 = pulseWidth;
    LPC_PWM1->LER = (1 << 4);
}

void scanKeypad(unsigned char *key) {
    unsigned char row;
    unsigned long temp, temp3;

    for (row = 0; row < 4; row++) {
        if (row == 0)
            temp = (1 << 10);
        else if (row == 1)
            temp = (1 << 11);
        else if (row == 2)
            temp = (1 << 12);
        else if (row == 3)
            temp = (1 << 13);

        LPC_GPIO2->FIOCLR = (15 << 10);
        LPC_GPIO2->FIOSET = temp;

        temp3 = LPC_GPIO1->FIOPIN & (15 << 23);

        if (temp3 != 0) {
            temp3 >>= 23;
            *key = SCAN_CODE[row] | temp3;
            return;
        }
    }

    *key = '\0';
}

int main(void) {
    unsigned char key;
    unsigned int i;

    SystemInit();
    SystemCoreClockUpdate();

    LPC_GPIO2->FIODIR |= (15 << 10);
    LPC_GPIO1->FIODIR &= ~(15 << 23);

    initPWM();

    while (1) {
        scanKeypad(&key);

        for (i = 0; i < 4; i++) {
            if (key == SCAN_CODE[i]) {
                updatePulseWidth(intensityLevels[i]);
                break;
            }
        }
    }

    return 0;
}
