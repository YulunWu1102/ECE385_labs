/*
 * text_mode_vga_color.c
 * Minimal driver for text mode VGA support
 * This is for Week 2, with color support
 *
 *  Created on: Oct 25, 2021
 *      Author: zuofu
 */

#include <system.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <alt_types.h>
#include "text_mode_vga_color.h"

void textVGAColorClr()
{
	for (int i = 0; i<(ROWS*COLUMNS) * 2; i++)
	{
		vga_ctrl->VRAM[i] = 0x00;
	}
}

void textVGADrawColorText(char* str, int x, int y, alt_u8 background, alt_u8 foreground)
{
	int i = 0;
	while (str[i]!=0)
	{
		vga_ctrl->VRAM[(y*COLUMNS + x + i) * 2] = foreground << 4 | background;
		vga_ctrl->VRAM[(y*COLUMNS + x + i) * 2 + 1] = str[i];
		i++;
	}
}

void setColorPalette (alt_u8 color, alt_u8 red, alt_u8 green, alt_u8 blue)
{
	//fill in this function to set the color palette starting at offset 0x0000 2000 (from base)

}


void textVGAColorScreenSaver()
{
	//This is the function you call for your week 2 demo
	char color_string[80];
    int fg, bg, x, y;
	textVGAColorClr();
	//initialize palette
	for (int i = 0; i < 8; i++)
	{
        alt_u32 red2=colors[2*i+1].red;
        for(int i=0;i<21;i++){
        	red2=red2<<1;
        }
        alt_u32 green2=colors[2*i+1].green;
        for(int i=0;i<17;i++){
        	green2=green2<<1;
        }
        alt_u32 blue2=colors[2*i+1].blue;
        for(int i=0;i<13;i++){
        	blue2=blue2<<1;
        }
        alt_u32 red1=colors[2*i].red;
        for(int i=0;i<9;i++){
        	red1=red1<<1;
        }
        alt_u32 green1=colors[2*i].green;
        for(int i=0;i<5;i++){
        	green1=green1<<1;
        }
        alt_u32 blue1=colors[2*i].blue;
        for(int i=0;i<1;i++){
        	blue1=blue1<<1;
        }
        alt_u32 total=(red1|green1|blue1|red2|green2|blue2);
        vga_ctrl->PALETTE [i]=total;

	}
	while (1)
	{
		fg = rand() % 16;
		bg = rand() % 16;
		while (fg == bg)
		{
			fg = rand() % 16;
			bg = rand() % 16;
		}
		sprintf(color_string, "Drawing %s text with %s background", colors[fg].name, colors[bg].name);
		x = rand() % (80-strlen(color_string));
		y = rand() % 30;
		textVGADrawColorText (color_string, x, y, bg, fg);
		usleep (100000);
	}
}
