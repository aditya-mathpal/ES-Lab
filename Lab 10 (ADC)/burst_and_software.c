#include "lcd-disp.c"

#define Ref_Vtg 3.300
#define Full_Scale 0xFFF

void ADC_Init(void) {
    LPC_SC->PCONP |= (1 << 12);
    LPC_PINCON->PINSEL3 |= (3 << 28) | (3 << 30);
    LPC_ADC->ADCR = (1 << 4) | (1 << 5) | (4 << 8) | (1 << 21);
}

unsigned int ADC_Read(unsigned char channel) {
    LPC_ADC->ADCR &= ~(0xFF);
    LPC_ADC->ADCR |= (1 << channel);
    LPC_ADC->ADCR |= (1 << 24);

    while (!(LPC_ADC->ADDR[channel] & (1 << 31)));

    unsigned int result = (LPC_ADC->ADDR[channel] >> 4) & Full_Scale;
    return result;
}

void ADC_BurstMode(void) {
    LPC_ADC->ADCR |= (1 << 16);
}

int main(void) {
    unsigned int adc_value_4, adc_value_5, diff_value;
    float voltage_4, voltage_5, diff_voltage;
    char display_buffer[16];

    SystemInit();
    SystemCoreClockUpdate();
    lcd_init();
    
    ADC_Init();
    ADC_BurstMode();

    lcd_comdata(0x80, 0);
    lcd_puts("Voltage Diff:");

    while (1) {
        adc_value_4 = ADC_Read(4);
        adc_value_5 = ADC_Read(5);

        voltage_4 = ((float)adc_value_4 * Ref_Vtg) / Full_Scale;
        voltage_5 = ((float)adc_value_5 * Ref_Vtg); 
        diff_voltage = voltage_4 - voltage_5;

        diff_value = adc_value_4 - adc_value_5;

        sprintf(display_buffer, "%3.2fV", diff_voltage);
        lcd_comdata(0xC0, 0);
        lcd_puts(display_buffer);

        delay_lcd(100000);
    }

    return 0;
}
