#include "lcd-disp.c"

#define Ref_Vtg    3.300
#define Full_Scale 0xFFF

volatile unsigned int adc_value_4 = 0, adc_value_5 = 0;

void ADC_Init(void) {
    LPC_SC->PCONP |= (1 << 12);
    LPC_PINCON->PINSEL3 |= (3 << 28) | (3 << 30);
    LPC_ADC->ADCR = (1 << 4) | (1 << 5) | (4 << 8) | (1 << 21);
    LPC_ADC->ADINTEN = (1 << 4) | (1 << 5);
    NVIC_EnableIRQ(ADC_IRQn);
}

void ADC_BurstMode(void) {
    LPC_ADC->ADCR |= (1 << 16);
}

void ADC_IRQHandler(void) {
    if (LPC_ADC->ADDR4 & (1 << 31)) {
        adc_value_4 = (LPC_ADC->ADDR4 >> 4) & Full_Scale;
    }
    if (LPC_ADC->ADDR5 & (1 << 31)) {
        adc_value_5 = (LPC_ADC->ADDR5 >> 4) & Full_Scale;
    }
}

int main(void) {
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
        voltage_4 = ((float)adc_value_4 * Ref_Vtg) / Full_Scale;
        voltage_5 = ((float)adc_value_5 * Ref_Vtg) / Full_Scale;
        diff_voltage = voltage_4 - voltage_5;

        sprintf(display_buffer, "%3.2fV", diff_voltage);
        lcd_comdata(0xC0, 0);
        lcd_puts(display_buffer);

        delay_lcd(100000);
    }

    return 0;
}
