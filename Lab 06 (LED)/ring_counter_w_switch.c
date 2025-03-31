#include<LPC17XX.h>

int main() {
    SystemInit();
	SystemCoreClockUpdate();
    unsigned int curr, msb, i, sw, start = 1;

    LPC_PINCON->PINSEL0 &= ~(0xFFFF<<8);
	LPC_GPIO0->FIODIR |= (0xFF<<4);
	
	LPC_GPIO0->FIOCLR |= (0xFF<<4);
	LPC_GPIO0->FIOSET |= (0x01<<4);

	while(1) {
		sw = (LPC_GPIO0->FIOPIN & (1 << 21)) >> 21;
		if (sw == 0) {
			curr = (LPC_GPIO0->FIOPIN & (0xFF<<4)) >> 4;
			msb = curr >> 7;
			curr = ((curr << 1) & 0xFF) | msb;
		
			LPC_GPIO0->FIOCLR |= (0xFF<<4);
			LPC_GPIO0->FIOSET |= (curr<<4);
		
			for(i = 0; i < 30000; i++);
		}
	}
}