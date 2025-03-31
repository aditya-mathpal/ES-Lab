#include<LPC17xx.h>

unsigned long temp, temp3, flag, key, var1, i;

unsigned char SCAN_CODE[8] = {0x11, 0x21, 0x41, 0x81,
                              0x12, 0x22, 0x42, 0x82}

unsigned char tohex[8] = {0x3F, 0x06, 0x5B, 0x4F,
                          0x66, 0x6D, 0x7D, 0x07};

void scan() {
    temp3 = LPC_GPIO0->FIOPIN;
    temp3 &= (0xF << 4);
    if (temp3) {
        flag = 1;
        temp3 >>= 4;
        temp >>= 8;
        key = temp3 | temp;
    }
}

int main() {
    LPC_GPIO0->FIODIR |= 0xF << 8; // 0.8 to 0.11 as output (rows)
    LPC_GPIO0->FIODIR &= ~(0xF << 4); // 0.4 to 0.7 as input (cols)
    LPC_GPIO1->FIODIR |= 0xF << 15; // enable lines
    LPC_GPIO2->FIODIR |= 0xFF; // data lines
    while(1) {
        for(row = 1; row <= 4; row++) {
            var1 = 1 << (8+row);
            temp = var1;
            LPC_GPIO0->FIOCLR = 0xF << 8; // clear row output
            LPC_GPIO0->FIOSET = var1;
            flag = 0;
            scan();
            if(flag) break;
        }
        if(!flag) break;
        for(i = 0; i < 8; i++) {
            if(key == SCAN_CODE[i]) {
                key = tohex[i];
                break;
            }
        }
        LPC_GPIO2->FIOPIN = key;
        LPC_GPIO1->FIOSET = 1 << 15;
        for(i = 0; i < 3000; i++);
        LPC_GPIO1->FIOCLR = 1 << 15;
    }
    return 0;
}