// Main.c - makes LEDG0 on DE2-115 board blink if NIOS II is set up correctly
// for ECE 385 - University of Illinois - Electrical and Computer Engineering
// Author: Zuofu Cheng

int main()
{
	//int i = 0;
	volatile unsigned int *LED_PIO = (unsigned int*)0x80; //make a pointer to access the led block
	volatile unsigned int *SW	   = (unsigned int*)0x50; //make a pointer to access the SW block
	volatile unsigned int *KEY0	   = (unsigned int*)0x60; //make a pointer to access the key0 block
	volatile unsigned int *KEY1	   = (unsigned int*)0x70; //make a pointer to access the key1 block

	volatile unsigned int sum = 0;
	volatile unsigned int flag = 0; //declare a flag to avoid unwanted consecutive summation

	*LED_PIO = 0; //clear all LEDs
	while ( (1+1) != 3) //infinite loop
	{
		if(*KEY0 == 0x0){ //check if the reset is pressed (it's actively low by system default setting)
			sum = 0;	//clear the sum, the number sent to LED_PIO shall be all zero, and LED will all turn off
		}

		if(*KEY1 == 0x1){//check if the accumulate is pressed (it's actively low by system default setting)
			//sum += *SW;
			flag = 1; //we raise the flag value
		}

		if((flag == 1)&&(*KEY1 == 0)){ //when flag is high and we're not in reset mode
			sum += *SW; //add the value in the SW to variable sum
			flag = 0;	//reset the flag value to 0 again
		}

		*LED_PIO = sum; //set LSB


//		for (i = 0; i < 100000; i++); //software delay
//				*LED_PIO |= 0b1; //set LSB
//				for (i = 0; i < 100000; i++); //software delay
//				*LED_PIO &= ~0b1; //clear LSB
	}


	return 1; //never gets here
}
