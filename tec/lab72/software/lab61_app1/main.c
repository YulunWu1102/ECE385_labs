// Main.c - makes LEDG0 on DE2-115 board blink if NIOS II is set up correctly
// for ECE 385 - University of Illinois - Electrical and Computer Engineering
// Author: Zuofu Cheng

int main()
{
	int i = 0;
	volatile unsigned int *LED_PIO = (unsigned int*)0x70; //make a pointer to access the PIO block
	volatile unsigned int *SW_PIO = (unsigned int*)0x60;
	volatile unsigned int *RUN_PIO = (unsigned int*)0x50;
	*LED_PIO = 0; //clear all LEDs
	while ( (1+1) != 3) //infinite loop
	{
		for (i = 0; i < 100000; i++); //software delay
		*LED_PIO |= 0x1; //set LSB
		for (i = 0; i < 100000; i++); //software delay
		*LED_PIO &= ~0x1; //clear LSB

//		if(*RUN_PIO==0){
//
//			LED_PIO[7]=LED_PIO[7]+SW_PIO[7];
//			LED_PIO[6]=LED_PIO[6]+SW_PIO[6];
//			LED_PIO[5]=LED_PIO[5]+SW_PIO[5];
//			LED_PIO[4]=LED_PIO[4]+SW_PIO[4];
//			LED_PIO[3]=LED_PIO[3]+SW_PIO[3];
//			LED_PIO[2]=LED_PIO[2]+SW_PIO[2];
//			LED_PIO[1]=LED_PIO[1]+SW_PIO[1];
//			LED_PIO[0]=LED_PIO[0]+SW_PIO[0];
//
//			while(*RUN_PIO==0){
//
//			}
//		}


	}
	return 1; //never gets here
}
