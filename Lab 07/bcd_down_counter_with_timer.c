#include<LPC17xx.h>

unsigned char tohex[10]={0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F};

unsigned int i,j;

void downCounter(unsigned int* digit) {
	int borrow = 1;
	for(i = 3; i<4; i--) {
		if(digit[i] >= borrow) {
			digit[i] -= borrow;
			borrow = 0;
		}
		else {
			digit[i] = 9;
			borrow = 1;
		}
	}
}

void delayTimer (unsigned int seconds) {
	LPC_TIM0->TC =0;
	LPC_TIM0->TCR = 0x02;
	LPC_TIM0->TCR = 0x01;
	while(LPC_TIM0->TC < seconds);
	LPC_TIM0->TCR = 0x00;
}

int main(){
	  unsigned int arr[4]={9,9,9,9};
		LPC_PINCON->PINSEL0=0x0;
		LPC_PINCON->PINSEL3=0x0;
    LPC_GPIO0->FIODIR|=0xFF<<4;
    LPC_GPIO1->FIODIR|=0xF<<23;
    while(1){
			downCounter(arr);
        for(i=0;i<4;i++){
            LPC_GPIO1->FIOPIN=i<<23;
            LPC_GPIO0->FIOPIN=tohex[arr[3-i]]<<4;
						delayTimer(10000);
        }
				delayTimer(1);
    }
}
