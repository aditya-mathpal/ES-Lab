#include<LPC17XX.h>

int main() {
    SystemInit();
	SystemCoreClockUpdate();
    unsigned int i = 0, j, sw;

    LPC_PINCON->PINSEL0 &= ~(0xFFFF<<8);
	LPC_PINCON->PINSEL1 &= ~(0x03<<10); 
	
	LPC_GPIO0->FIODIR |= (0xFF<<4);
	LPC_GPIO0->FIODIR &= ~(0x1<<21);

	while(1) {
		sw = (LPC_GPIO0->FIOPIN & (1 << 21)) >> 21;
		if (sw == 1) i = i+1;
		else i = i-1;
		
		LPC_GPIO0->FIOPIN = i << 4;
		for(j = 0; j < 30000; j++);
		
		if (i == 255 && sw==1) i = 0;
		if (i == 0 && sw==0) i = 255;
	}
}