#include "plasma.h"

#define MemoryRead(A) (*(volatile unsigned int*)(A))
#define MemoryWrite(A,V) *(volatile unsigned int*)(A)=(V)

int putchar(int value)
{
   while((MemoryRead(IRQ_STATUS) & IRQ_UART_WRITE_AVAILABLE) == 0)
      ;
   MemoryWrite(UART_WRITE, value);
   return 0;
}

int puts(const char *string)
{
   while(*string)
   {
      if(*string == '\n')
         putchar('\r');
      putchar(*string++);
   }
   return 0;
}

void print_hex(unsigned long num)
{
   long i;
   unsigned long j;
   for(i = 28; i >= 0; i -= 4) 
   {
      j = (num >> i) & 0xf;
      if(j < 10) 
         putchar('0' + j);
      else 
         putchar('a' - 10 + j);
   }
}

void OS_InterruptServiceRoutine(unsigned int status)
{
   (void)status;
   putchar('I');
}

int kbhit(void)
{
   return MemoryRead(IRQ_STATUS) & IRQ_UART_READ_AVAILABLE;
}

int getch(void)
{
   while(!kbhit()) ;
   return MemoryRead(UART_READ);
}



// Code perso

char *itoa10(unsigned long num)
{
   static char buf[12];
   int i;
   buf[10] = 0;
   for (i = 9; i >= 0; --i)
   {
      buf[i] = (char)((num % 10) + '0');
      num /= 10;
   }
   return buf;
}

// Chenillard pilote des sorties
int chenillard_val [9] =
{
	0x00, 0x01, 0x02,
	0x04, 0x08, 0x10,
	0x20, 0x40, 0x80
};

void Led(int value)
{
 MemoryWrite(GPIO0_CLEAR, (~value) & 0xffff); //clear
 MemoryWrite(GPIO0_OUT, value); //Change LEDs
}

void delay (int ms)
{
	unsigned long for_delay = ms*(20000/4), i;
	for (i = 0; i < for_delay; i ++);
}


// Pilote des entrees
int SW(void) /* pilote qui renvoie entre 0 et 255 suivant la position des switch */
{
	return (MemoryRead(GPIOA_IN) & 0xffff);
}

int BTN_R(void) /* pilote qui renvoie 1 si le bouton correspondant est à 1 */
{
	return (MemoryRead(GPIOA_IN) & 1<<19) >> 19;
}
int BTN_L(void) /* pilote qui renvoie 1 si le bouton correspondant est à 1 */
{
	return (MemoryRead(GPIOA_IN) & 1<<18) >> 18;
}
int BTN_U(void) /* pilote qui renvoie 1 si le bouton correspondant est à 1 */
{
	return (MemoryRead(GPIOA_IN) & 1<<17) >> 17;
}
int BTN_D(void) /* pilote qui renvoie 1 si le bouton correspondant est à 1 */
{
	return (MemoryRead(GPIOA_IN) & 1<<16) >> 16;
}



void VGA_COLOR(int value)
{
//ALIGNEMENT DE LA VARIABLE VALUE PAR DECALAGE A GAUCHE DE X BITS
value=value<<20;
MemoryWrite(GPIO1_CLEAR, (~value) & 0xfff00000); //clear
MemoryWrite(GPIO1_OUT, value); //set
} 


void VGA_SPRITE(int x, int y)
{
	int value=y<<10 | x;
	MemoryWrite(GPIO1_CLEAR, (~value) & 0x000fffff); //clear
	MemoryWrite(GPIO1_OUT, value);	
}


void VGA_SPRITE2(int x, int y)
{
	int value=y<<10 | x;
	MemoryWrite(GPIO2_CLEAR, (~value) & 0x000fffff); //clear
	MemoryWrite(GPIO2_OUT, value);	
}


void VGA_SPRITE3(int x, int y)
{
	int value=y<<10 | x;
	MemoryWrite(GPIO3_CLEAR, (~value) & 0x000fffff); //clear
	MemoryWrite(GPIO3_OUT, value);	
}


void VGA_SPRITE4(int x, int y)
{
	int value=y<<10 | x;
	MemoryWrite(GPIO4_CLEAR, (~value) & 0x000fffff); //clear
	MemoryWrite(GPIO4_OUT, value);	
}

void VGA_SPRITE5(int x, int y)
{
	int value=y<<10 | x;
	MemoryWrite(GPIO5_CLEAR, (~value) & 0x000fffff); //clear
	MemoryWrite(GPIO5_OUT, value);	
	puts(itoa10(value));
}


void VGA_SPRITE6(int x, int y)
{
	int value=y<<10 | x;
	MemoryWrite(GPIO6_CLEAR, (~value) & 0x000fffff); //clear
	MemoryWrite(GPIO6_OUT, value);	
}
void VGA_SPRITE7(int x, int y)
{
	int value=y<<10 | x;
	MemoryWrite(GPIO7_CLEAR, (~value) & 0x000fffff); //clear
	MemoryWrite(GPIO7_OUT, value);	
}


 void SEG7(char E4, char E3, char E2, char E1) 
{
	//ALIGNEMENT DES PARAMETRES PAR DECALAGE A GAUCHE DE X BITS
	 int tmp=E4<<16 | E3<<20 | E2<<24 | E1<<28 ;
	 MemoryWrite(GPIO0_CLEAR, (~tmp) & 0xffff0000); //clear
	 MemoryWrite(GPIO0_OUT, tmp); //set
 } 



/* void SEG7b(char E4, char E3, char E2, char E1) {
	//ALIGNEMENT DES PARAMETRES PAR DECALAGE A GAUCHE DE X BITS
	int tmp=E4<<24 | E3<<16 | E2<<8 | E1<<0 ;
	MemoryWrite(GPIO1_CLEAR, (~tmp) & 0xffffffff); //clear
	MemoryWrite(GPIO1_OUT, tmp); //set
} 
 */