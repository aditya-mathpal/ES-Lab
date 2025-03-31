#include "lcd-disp.c"     // use all the functions of lcd program

void scan(void);

unsigned char Msg1[13] = "ENTER EXP:  =";
unsigned char row, var, flag, key;
unsigned long int i, var1, temp, temp2, temp3;
unsigned char input[4];    // To store A, operator, B, and =
unsigned char pos = 0;     // Current position in input
unsigned char result[2];   // To store result (max 2 digits)
unsigned char SCAN_CODE[16] = {0x11, 0x21, 0x41, 0x81,
                              0x12, 0x22, 0x42, 0x82,
                              0x14, 0x24, 0x44, 0x84,
                              0x18, 0x28, 0x48, 0x88};
unsigned char ASCII_CODE[16] = {'0', '1', '2', '3',
                               '4', '5', '6', '7',
                               '8', '9', '+', '-',
                               'C', 'D', 'E', '='};

int main(void)
{
    LPC_GPIO2->FIODIR |= 0x00003C00;  // made output P2.10 to P2.13 (rows)
    LPC_GPIO1->FIODIR &= 0xF87FFFFF;  // made input P1.23 to P1.26(cols)
    LPC_GPIO0->FIODIR |= 0x0F << 23 | 1 << 27 | 1 << 28;
    
    clear_ports();
    delay_lcd(3200);
    lcd_init();

    lcd_comdata(0x80, 0);     // point to first line of LCD
    delay_lcd(800);
    lcd_puts(&Msg1[0]);       // display "ENTER EXP:  ="

    while (1)
    {
        while (pos < 4)       // Get 4 characters: A, operator, B, =
        {
            for (row = 1; row < 5; row++)
            {
                if (row == 1) var1 = 0x00000400;
                else if (row == 2) var1 = 0x00000800;
                else if (row == 3) var1 = 0x00001000;
                else if (row == 4) var1 = 0x00002000;

                temp = var1;
                LPC_GPIO2->FIOCLR = 0x00003C00;
                LPC_GPIO2->FIOSET = var1;
                flag = 0;
                scan();
                
                if (flag == 1)
                {
                    for (i = 0; i < 16; i++)
                    {
                        if (key == SCAN_CODE[i])
                        {
                            key = ASCII_CODE[i];
                            break;
                        }
                    }
                    
                    // Validate input
                    if (pos == 0 && key >= '0' && key <= '9') {         // A must be 0-9
                        input[pos] = key;
                        pos++;
                    }
                    else if (pos == 1 && (key == '+' || key == '-')) {  // Operator: + or -
                        input[pos] = key;
                        pos++;
                    }
                    else if (pos == 2 && key >= '0' && key <= '9') {    // B must be 0-9
                        input[pos] = key;
                        pos++;
                    }
                    else if (pos == 3 && key == '=') {                  // = for equals
                        input[pos] = key;
                        pos++;
                    }

                    // Display input character
                    lcd_comdata(0x8A + pos - 1, 0);  // Position cursor
                    delay_lcd(800);
                    lcd_puts(&key);
                    break;
                }
            }
        }

        // Calculate result
        temp = input[0] - '0';    // Convert ASCII to number
        temp2 = input[2] - '0';
        
        if (input[1] == '+') {    // Addition
            temp3 = temp + temp2;
        } else {                  // Subtraction
            temp3 = temp - temp2;
        }

        // Convert result to ASCII
        if (temp3 < 0) {
            result[0] = '-';
            result[1] = (0 - temp3) + '0';
        } else if (temp3 >= 10) {
            result[0] = '1';
            result[1] = (temp3 - 10) + '0';
        } else {
            result[0] = ' ';
            result[1] = temp3 + '0';
        }

        // Display result
        lcd_comdata(0xC0, 0);     // Second line
        delay_lcd(800);
        lcd_puts(&result[0]);
        
        pos = 0;                  // Reset for next expression
    }
}

void scan(void)
{
    temp3 = LPC_GPIO1->FIOPIN;
    temp3 &= 0x07800000;
    if (temp3 != 0x00000000)
    {
        flag = 1;
        temp3 >>= 19;
        temp >>= 10;
        key = temp3 | temp;
    }
}