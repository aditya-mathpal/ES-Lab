#include<LPC17xx.h>

unsigned int dig[4] = {0x66, 0x4F, 0x5B, 0x6};
unsigned int i,j;

int main(){
		LPC_PINCON->PINSEL0=0x0;
		LPC_PINCON->PINSEL3=0x0;
    LPC_GPIO0->FIODIR|=0xFF<<4;
    LPC_GPIO1->FIODIR|=0xF<<23;
    while(1){
        for(i=0;i<4;i++){
            LPC_GPIO1->FIOPIN=i<<23;
            LPC_GPIO0->FIOPIN=dig[i]<<4;
            for(j=0;j<1000;j++);
        }
    }
}
