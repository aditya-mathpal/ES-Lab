#include <LPC17xx.h>
#include "lcd-disp.c"   // using your provided lcd display routines

/* Function Prototypes */
unsigned char get_key(void);
void int_to_str(int num, char *str);

/* get_key()
   Scans the keypad and returns the ASCII character corresponding to the pressed key.
   The keypad is assumed to be wired as follows:
   - Rows: P2.10 to P2.13 (configured as output)
   - Columns: P1.23 to P1.26 (configured as input)
   The mapping used here (from scan code to ASCII) is:
       Row1: '1', '2', '3', '+'
       Row2: '4', '5', '6', '-'
       Row3: '7', '8', '9', '='
       Row4: '0', ' ', ' ', ' '
*/
unsigned char get_key(void)
{
    unsigned char SCAN_CODE[16] = {0x11, 0x21, 0x41, 0x81,
                                   0x12, 0x22, 0x42, 0x82,
                                   0x14, 0x24, 0x44, 0x84,
                                   0x18, 0x28, 0x48, 0x88};
    unsigned char ASCII_CODE[16] = {'1','2','3','+',
                                    '4','5','6','-',
                                    '7','8','9','=',
                                    '0',' ',' ',' '};
    unsigned int row, var1, temp, temp3;
    unsigned char key_scan = 0;
    int flag = 0;
    
    while(1)
    {
        for(row = 1; row <= 4; row++)
        {
            if(row == 1)
                var1 = 0x00000400;  // P2.10
            else if(row == 2)
                var1 = 0x00000800;  // P2.11
            else if(row == 3)
                var1 = 0x00001000;  // P2.12
            else // row == 4
                var1 = 0x00002000;  // P2.13
            
            temp = var1;
            // Clear all row bits (P2.10 to P2.13)
            LPC_GPIO2->FIOCLR = 0x00003C00;
            // Enable the current row
            LPC_GPIO2->FIOSET = var1;
            
            // Read column inputs (columns on P1.23 to P1.26, mask 0x07800000)
            temp3 = LPC_GPIO1->FIOPIN;
            temp3 &= 0x07800000;
            
            if(temp3 != 0)
            {
                flag = 1;
                // Normalize column data: shift columns to LSB position
                temp3 = temp3 >> 19;
                // Normalize row data: shift row identifier (var1) right by 10 bits
                temp = temp >> 10;
                // Combine row and column to form the scan code
                key_scan = (unsigned char)(temp3 | temp);
                
                // Wait until the key is released to avoid multiple reads
                while((LPC_GPIO1->FIOPIN & 0x07800000) != 0);
                delay_lcd(5000);
                
                // Match the scan code to return the corresponding ASCII character
                int i;
                for(i = 0; i < 16; i++)
                {
                    if(key_scan == SCAN_CODE[i])
                        return ASCII_CODE[i];
                }
            }
        }
    }
}

/* int_to_str()
   Converts a non-negative integer (up to two digits) to a null-terminated string.
*/
void int_to_str(int num, char *str)
{
    int i = 0, j, rem;
    char temp[3];  // buffer for up to 2 digits
    if(num == 0)
    {
        str[i++] = '0';
        str[i] = '\0';
        return;
    }
    while(num > 0)
    {
        rem = num % 10;
        temp[i++] = '0' + rem;
        num /= 10;
    }
    temp[i] = '\0';
    // Reverse the string to get the correct order
    for(j = 0; j < i; j++)
    {
        str[j] = temp[i - j - 1];
    }
    str[i] = '\0';
}

int main(void)
{
    char expr[6];    // to hold the 4 keypresses and a null terminator, e.g., "1+2="
    char res_str[4]; // to hold the result (up to 2 digits + null terminator)
    int A, B, result;
    char op;
    char disp[10];   // buffer to display the complete expression and result, e.g., "1+2=3"
    int j;
    
    // Configure keypad ports:
    // Rows: P2.10 to P2.13 as output
    LPC_GPIO2->FIODIR |= 0x00003C00;
    // Columns: P1.23 to P1.26 as input (leave default)
    LPC_GPIO1->FIODIR &= 0xF87FFFFF;
    
    // Initialize the LCD
    lcd_init();
    // Position cursor at the beginning of the first line
    lcd_comdata(0x80, 0);
    
    /* 
       Wait for the user to enter an expression of the form: A operator B = 
       (for example: 1 + 2 = )
    */
    expr[0] = get_key();  // Read first digit (A)
    expr[1] = get_key();  // Read operator (+ or -)
    expr[2] = get_key();  // Read second digit (B)
    expr[3] = get_key();  // Read '=' key
    expr[4] = '\0';
    
    // Convert the operands from characters to integers
    A = expr[0] - '0';
    B = expr[2] - '0';
    op = expr[1];
    
    // Compute the result based on the operator
    if(op == '+')
        result = A + B;
    else if(op == '-')
        result = A - B;
    else
        result = 0;  // default case; should not occur in proper usage
    
    // Prepare the display string: concatenate the expression and the computed result
    // Start with the expression "A operator B =" 
    disp[0] = expr[0];
    disp[1] = expr[1];
    disp[2] = expr[2];
    disp[3] = expr[3];
    disp[4] = '\0';
    
    // Convert the result integer to string
    int_to_str(result, res_str);
    // Append the result string to the display string
    j = 0;
    while(res_str[j] != '\0')
    {
        disp[4 + j] = res_str[j];
        j++;
    }
    disp[4 + j] = '\0';
    
    // Move the LCD cursor to the second line (0xC0 is the DDRAM address for line 2)
    lcd_comdata(0xC0, 0);
    // Display the complete string on the LCD
    lcd_puts((unsigned char*)disp);
    
    // Loop indefinitely
    while(1);
    
    return 0;
}
