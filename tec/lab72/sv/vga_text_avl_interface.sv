/************************************************************************
Avalon-MM Interface VGA Text mode display

Register Map:
0x000-0x0257 : VRAM, 80x30 (2400 byte, 600 word) raster order (first column then row)
0x258        : control register

VRAM Format:
X->
[ 31  30-24][ 23  22-16][ 15  14-8 ][ 7    6-0 ]
[IV3][CODE3][IV2][CODE2][IV1][CODE1][IV0][CODE0]

IVn = Draw inverse glyph
CODEn = Glyph code from IBM codepage 437

Control Register Format:
[[31-25][24-21][20-17][16-13][ 12-9][ 8-5 ][ 4-1 ][   0    ] 
[[RSVD ][FGD_R][FGD_G][FGD_B][BKG_R][BKG_G][BKG_B][RESERVED]

VSYNC signal = bit which flips on every Vsync (time for new frame), used to synchronize software
BKG_R/G/B = Background color, flipped with foreground when IVn bit is set
FGD_R/G/B = Foreground color, flipped with background when Inv bit is set

************************************************************************/
//`define NUM_REGS  //80*30 characters / 4 characters per register
//`define CTRL_REG 600 //index of control register

module vga_text_avl_interface (
	// Avalon Clock Input, note this clock is also used for VGA, so this must be 50Mhz
	// We can put a clock divider here in the future to make this IP more generalizable
	input logic CLK,
	
	// Avalon Reset Input
	input logic RESET,
	
	// Avalon-MM Slave Signals
	input  logic AVL_READ,					// Avalon-MM Read
	input  logic AVL_WRITE,					// Avalon-MM Write
	input  logic AVL_CS,					// Avalon-MM Chip Select
	input  logic [3:0] AVL_BYTE_EN,			// Avalon-MM Byte Enable
	input  logic [11:0] AVL_ADDR,			// Avalon-MM Address
	input  logic [31:0] AVL_WRITEDATA,		// Avalon-MM Write Data
	output logic [31:0] AVL_READDATA,		// Avalon-MM Read Data
	
	// Exported Conduit (mapped to VGA port - make sure you export in Platform Designer)
	output logic [3:0]  red, green, blue,	// VGA color channels (mapped to output pins in top-level)
	output logic hs, vs						// VGA HS/VS
);


logic [31:0] REG [8]; // Registers

//put other local variables here

logic [31:0] VRAMID;
logic [6:0] CODE;
logic [3:0] BKG_IDX;
logic [3:0] FGD_IDX;
logic IV;
logic pixelvalue;
logic PIXEL_CLK;
logic BLANK;
logic SYNC;
logic [9:0] drawX, drawY;
logic [10:0] address;
logic [7:0] DATA;
logic [11:0] BA;
logic [10:0] WA;

//Declare submodules..e.g. VGA controller, ROMS, etc
vga_controller vc (.Clk(CLK), .Reset(RESET), .hs(hs), .vs(vs),.pixel_clk(PIXEL_CLK), .blank(BLANK),.sync(SYNC), .DrawX(drawX),.DrawY(drawY));

   
// Read and write from AVL interface to register block, note that READ waitstate = 1, so this should be in always_ff
mem MEM (.wraddress(AVL_ADDR),.rdaddress(WA),.byteena_a(AVL_BYTE_EN),.clock(CLK),.data(AVL_WRITEDATA),.wren(AVL_WRITE && AVL_CS && !AVL_ADDR[11]),.q(VRAMID));

	
font_rom fr (.addr(address), .data(DATA));
// Read and write from AVL interface to register block, note that READ waitstate = 1, so this should be in always_ff
always_ff @(posedge CLK) 
begin
	if (RESET)
		REG [AVL_ADDR[2:0]] <= 32'b0;
	else if (AVL_WRITE && AVL_CS && AVL_ADDR[11]) 
	begin
		REG [AVL_ADDR[2:0]] [7:0] <= AVL_WRITEDATA[7:0];
		REG [AVL_ADDR[2:0]] [15:8] <= AVL_WRITEDATA[15:8];
		REG [AVL_ADDR[2:0]] [23:16] <= AVL_WRITEDATA[23:16];
		REG [AVL_ADDR[2:0]] [31:24] <= AVL_WRITEDATA[31:24];
	end
end

always_ff @(posedge PIXEL_CLK)
begin
	if (BLANK)
		begin
			if((pixelvalue==0&&IV==0)||(pixelvalue==1&&IV==1))
				begin
			
				if(!BKG_IDX[0])
				begin
					red <= REG [BKG_IDX[3:1]] [12:9];
					green <= REG [BKG_IDX[3:1]] [8:5];
					blue <= REG [BKG_IDX[3:1]] [4:1];
				end
				else
				begin
					red <= REG [BKG_IDX[3:1]] [24:21];
					green <= REG [BKG_IDX[3:1]] [20:17];
					blue <= REG [BKG_IDX[3:1]] [16:13];
				end
				end
				
			else
				begin	
				if(!FGD_IDX[0])
				begin
					red <= REG [FGD_IDX[3:1]] [12:9];
					green <= REG [FGD_IDX[3:1]] [8:5];
					blue <= REG [FGD_IDX[3:1]] [4:1];
				end
				else
				begin
					red <= REG [FGD_IDX[3:1]] [24:21];
					green <= REG [FGD_IDX[3:1]] [20:17];
					blue <= REG [FGD_IDX[3:1]] [16:13];
				end
				end

			
		end
	else
		begin
		   red <= 4'b0;
			green <= 4'b0;
			blue <= 4'b0;
		end
end	

//handle drawing (may either be combinational or sequential - or both).
always_comb
begin
	BA = drawY[9:4] * 80 + drawX[9:3];
	WA=BA[11:1];
	begin
		if(!BA[0])
		begin
			CODE = VRAMID[14:8];
			FGD_IDX = VRAMID[7:4];
			BKG_IDX = VRAMID[3:0];
			IV = VRAMID[15];
		end
		else if(BA[0])
		begin
		CODE = VRAMID[30:24];
		FGD_IDX = VRAMID[23:20];
		BKG_IDX = VRAMID[19:16];
		IV = VRAMID[31];
		end
		
	end
	begin
		if(drawX[2:0]==3'b000)
			begin
			pixelvalue = DATA[7]
			end
		else if(drawX[2:0]==3'b001)
			begin
			pixelvalue = DATA[6];
			end
		else if(drawX[2:0]==3'b010)
			begin
			pixelvalue = DATA[5];
			end
		else if(drawX[2:0]==3'b011)
			begin
			pixelvalue = DATA[4];
			end
		else if(drawX[2:0]==3'b100)
			begin
			pixelvalue = DATA[3];
			end
		else if(drawX[2:0]==3'b101)
			begin
			pixelvalue = DATA[2];
			end
		else if(drawX[2:0]==3'b110)
			begin
			pixelvalue = DATA[1];
			end
		else if(drawX[2:0]==3'b111)
			begin
			pixelvalue = DATA[0];
			end

		
		address = {CODE, drawY[3:0]};
	end
end



endmodule

