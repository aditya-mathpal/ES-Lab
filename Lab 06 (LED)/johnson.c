#include<LPC17XX.H>

int main() {
	unsigned int i, j, LED = 0X1<<4; // initially setting the leftmost pin
	LPC_PINCON->PINSEL0 = 0x0;
	LPC_PINCON->PINSEL1 = 0x0;
	LPC_GPIO0->FIODIR = 0xFF<<4;
	
	while(1) {
		LED = 0x1<<4;
		for(i = 1; i <= 8; i++) { // turning the leftmost ON, and then one by one all of them ON from left ot right
			LPC_GPIO0->FIOSET = LED;
			for(j = 1; j < 60000; j++);
			LED = LED<<1;
		}
		LED = 0x1<<4;
		for(i = 1; i <= 8; i++) { // turning them OFF one by one from left to right
			LPC_GPIO0->FIOCLR = LED;
			for(j = 0; j < 60000; j++);
			LED = LED<<1;
		}
	}
}
