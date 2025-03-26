#include<LPC17xx.h>

void clear_ports() {
    /* clearing the lines at power on */
    LPC_GPIO0->FIOCLR = 0x0F<<23; // clearing data lines
    LPC_GPIO0->FIOCLR = 1<<27; //clearing RS line
    LPC_GPIO0->FIOCLR = 1<<28; //clearing enable line
    return;
}

void delay_lcd(unsigned int r1) {
    unsigned int r;
    for(r=0;r<r1;r++);
    return;
}

void write(int temp2, int type) {
    clear_ports();
    LPC_GPIO0->FIOPIN = temp2; // Assign the value to the data lines
    if(type == 0) {
        LPC_GPIO0->FIOCLR = 1<<27; // RS is 0
    } else {
        LPC_GPIO0->FIOSET = 1<<27; // RS is 1
    }
    LPC_GPIO0->FIOSET = 1<<28; // generate enable
    delay_lcd(25);
    LPC_GPIO0->FIOCLR = 1<<28; // disable enable
    delay_lcd(1000);
    return;
}

void lcd_comdata(int temp1, int type) {
    int temp2 = temp1 & 0xF0; //move data (26-8+1) times : 26-HN place, 4 bits
    temp2 = temp2 << 19; //data lines from 23 to 26
    write(temp2, type); // call to write data
    temp2 = temp1 & 0x0F; //26-4+1
    temp2 = temp2 << 23; //data lines from 23 to 26
    write(temp2, type);
    delay_lcd(1000);
    return;
}

void lcd_init() {
    /* ports initialized as GPIO */
    LPC_PINCON->PINSEL1 &= 0xFC003FFF; //P0.23 to P0.28
    /* setting the directions as output */
    LPC_GPIO0->FIODIR |= 0x0F<<23 | 1<<27 | 1<<28;
    clear_ports();
    delay_lcd(3200);
    lcd_comdata(0x33, 0);
    delay_lcd(30000);
    lcd_comdata(0x32, 0);
    delay_lcd(30000);
    lcd_comdata(0x28, 0); //funciton set
    delay_lcd(30000);
    lcd_comdata(0x0c, 0); //display on cursor off
    delay_lcd(800);
    lcd_comdata(0x06, 0); //entry mode set increment cusor right
    delay_lcd(800);
    lcd_comdata(0x01, 0); //display clear
    delay_lcd(10000);
    return;
}

void lcd_puts(unsigned char* buf1) {
    unsigned int i=0;
    while(buf1[i] != '\0') {
        lcd_comdata(buf1[i], 1);
        i++;
        if(i == 16) {
            lcd_comdata(0xC0, 0);
        }
    }
    return;
}
