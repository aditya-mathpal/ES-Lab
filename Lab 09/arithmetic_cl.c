#include <LPC17xx.h>
#include "lcd-disp.c"

void scan(void);
void calculate_and_display(void);

unsigned char Msg1[20] = "Enter Expression:";
unsigned char Msg2[20] = "Result: ";
unsigned char expression[5];
unsigned char row, var, flag, key;
unsigned long int i, var1, temp, temp3;
int expr_index = 0;

unsigned char SCAN_CODE[16] = {0x11, 0x21, 0x41, 0x81,
                               0x12, 0x22, 0x42, 0x82,
                               0x14, 0x24, 0x44, 0x84,
                               0x18, 0x28, 0x48, 0x88};

unsigned char ASCII_CODE[16] = {'0', '1', '2', '3',
                                '4', '5', '6', '7',
                                '8', '9', '+', '-',
                                'C', 'D', '=', 'F'};

int main(void)
{
    LPC_GPIO2->FIODIR |= 0x00003C00; // make output P2.10 to P2.13 (rows)
    LPC_GPIO1->FIODIR &= 0xF87FFFFF; // make input P1.23 to P1.26 (cols)

    lcd_init();
    lcd_comdata(0x80, 0); // point to first line of LCD
    delay_lcd(800);
    lcd_puts(Msg1); // display the message

    while (1)
    {
        while (1)
        {
            for (row = 1; row < 5; row++)
            {
                if (row == 1)
                    var1 = 0x00000400;
                else if (row == 2)
                    var1 = 0x00000800;
                else if (row == 3)
                    var1 = 0x00001000;
                else if (row == 4)
                    var1 = 0x00002000;

                temp = var1;
                LPC_GPIO2->FIOCLR = 0x00003C00; // first clear the port and send appropriate value
                LPC_GPIO2->FIOSET = var1; // enabling the row

                flag = 0;
                scan(); // scan if any key pressed in the enabled row

                if (flag == 1)
                    break;
            }
            if (flag == 1)
                break;
        }

        for (i = 0; i < 16; i++) // get the ASCII code for display
        {
            if (key == SCAN_CODE[i])
            {
                key = ASCII_CODE[i];
                break;
            }
        }

        if (key >= '0' && key <= '9' || key == '+' || key == '-' || key == '=')
        {
            lcd_comdata(0xC0 + expr_index, 0); // move cursor to appropriate position
            delay_lcd(800);
            lcd_comdata(key, 1); // display the key
            expression[expr_index++] = key;

            if (key == '=' || expr_index >= 4)
            {
                calculate_and_display();
                expr_index = 0;
                lcd_comdata(0x01, 0); // clear display
                delay_lcd(10000);
                lcd_comdata(0x80, 0); // point to first line of LCD
                delay_lcd(800);
                lcd_puts(Msg1); // display the input message again
            }
        }
    }
}

void scan(void)
{
    temp3 = LPC_GPIO1->FIOPIN;
    temp3 &= 0x07800000; // check if any key pressed in the enabled row
    if (temp3 != 0x00000000)
    {
        flag = 1;
        temp3 >>= 19; // Shifted to come at HN of byte
        temp >>= 10; // shifted to come at LN of byte
        key = temp3 | temp; // get SCAN_CODE
    }
}

void calculate_and_display(void)
{
    int a = expression[0] - '0';
    int b = expression[2] - '0';
    int result;

    if (expression[1] == '+')
        result = a + b;
    else if (expression[1] == '-')
        result = a - b;

    lcd_comdata(0x01, 0); // clear display
    delay_lcd(10000);
    lcd_comdata(0x80, 0); // point to first line of LCD
    delay_lcd(800);
    lcd_puts(Msg2); // display "Result: "

    lcd_comdata(0xC0, 0); // move to second line
    delay_lcd(800);
    lcd_comdata(result + '0', 1); // display the result
    delay_lcd(20000); // wait for 2 seconds before clearing
}
