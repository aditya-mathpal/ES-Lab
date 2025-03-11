#include<LPC17xx.h>

unsigned char tohex[10]={0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F};
long int arr[4]={9,9,9,9};
unsigned int i,j;

int main(){
    LPC_GPIO0->FIODIR|=0xFF0;
    LPC_GPIO1->FIODIR|=0xF<<23;
    LPC_TIM0->CTCR=0x0;
    LPC_TIM0->PR=25000000-1;
    while(1){
        for(i=0;i<4;i++){
            LPC_GPIO1->FIOPIN=i<<23;
            LPC_GPIO0->FIOPIN=tohex[arr[i]]<<4;
            for(j=0;j<1000;j++);
        }
        if(LPC_TIM0->TC>=1000){
            LPC_TIM0->TCR=0x02;
            LPC_TIM0->TCR=0x01;
            arr[0]--;
            if(arr[0]<0){arr[0]=9;arr[1]--;
                if(arr[1]<0){arr[1]=9;arr[2]--;
                    if(arr[2]<0){arr[2]=9;arr[3]--;
                        if(arr[3]<0)arr[3]=9;}}}
        }
    }
}
