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
`define NUM_REGS 601 //80*30 characters / 4 characters per register
`define CTRL_REG 600 //index of control register

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
	input  logic [9:0] AVL_ADDR,			// Avalon-MM Address
	input  logic [31:0] AVL_WRITEDATA,		// Avalon-MM Write Data
	output logic [31:0] AVL_READDATA,		// Avalon-MM Read Data
	
	// Exported Conduit (mapped to VGA port - make sure you export in Platform Designer)
	output logic [3:0]  red, green, blue,	// VGA color channels (mapped to output pins in top-level)
	output logic hs, vs						// VGA HS/VS
);

logic [31:0] LOCAL_REG [`NUM_REGS]; // Registers
//put other local variables here
//logic VGA_Clk, blank, sync,CLK,RESET,hs,vs,blank;
//logic [9:0] drawxsig,drawysig;
//logic [7:0]AVL_ADDR;
//logic [31:0]AVL_READDATA;

//Declare submodules..e.g. VGA controller, ROMS, etc
//vga_controller vgacontrol(.Clk(CLK), .Reset(RESET), .hs(hs), .vs(vs), 
//									.pixel_clk(VGA_Clk), .blank(blank), .sync(sync),
//									.DrawX(drawxsig), .DrawY(drawysig));
//									
//font_rom roms(.addr(AVL_ADDR), .data(AVL_READDATA));

	
   
// Read and write from AVL interface to register block, note that READ waitstate = 1, so this should be in always_ff
always_ff @(posedge CLK) begin
   if(RESET)
	AVL_READDATA<=0;
	
	
	else if(AVL_CS&&AVL_WRITEDATA)
	begin
	if(AVL_BYTE_EN[0]==1)
	LOCAL_REG[AVL_ADDR][7:0]<=AVL_WRITEDATA[7:0];
	if(AVL_BYTE_EN[1]==1)
	LOCAL_REG[AVL_ADDR][15:8]<=AVL_WRITEDATA[15:8];
	if(AVL_BYTE_EN[2]==1)
	LOCAL_REG[AVL_ADDR][23:16]<=AVL_WRITEDATA[23:16];
	if(AVL_BYTE_EN[3]==1)
	LOCAL_REG[AVL_ADDR][31:24]<=AVL_WRITEDATA[31:24];
	end
	
	else if(AVL_CS&&AVL_READ)
	AVL_READDATA[31:0]<=LOCAL_REG[AVL_ADDR][31:0];
	
//	else if(AVL_CS&&AVL_WRITE)
//	begin
//	  if(AVL_BYTE_EN==4'b1111)
//	  LOCAL_REG[AVL_ADDR][31:0]<=AVL_WRITEDATA[31:0];
//	  if(AVL_BYTE_EN==4'b0001)
//	  LOCAL_REG[AVL_ADDR][7:0]<=AVL_WRITEDATA[7:0];
//	  if(AVL_BYTE_EN==4'b0010)
//	  LOCAL_REG[AVL_ADDR][15:8]<=AVL_WRITEDATA[15:8];
//	  if(AVL_BYTE_EN==4'b0100)
//	  LOCAL_REG[AVL_ADDR][23:16]<=AVL_WRITEDATA[23:16];
//	  if(AVL_BYTE_EN==4'b1000)
//	  LOCAL_REG[AVL_ADDR][31:24]<=AVL_WRITEDATA[31:24];
//	  if(AVL_BYTE_EN==4'b0011)
//	  LOCAL_REG[AVL_ADDR][15:0]<=AVL_WRITEDATA[15:0];
//	  if(AVL_BYTE_EN==4'b1100)
//	  LOCAL_REG[AVL_ADDR][31:16]<=AVL_WRITEDATA[31:16];
//	  if(AVL_BYTE_EN==4'b1110)
//	  begin
//	  LOCAL_REG[AVL_ADDR][31:16]<=AVL_WRITEDATA[31:16];
//	  LOCAL_REG[AVL_ADDR][15:8]<=AVL_WRITEDATA[15:8];
//	  end
//	  if(AVL_BYTE_EN==4'b0111)
//	  begin
//	  LOCAL_REG[AVL_ADDR][15:0]<=AVL_WRITEDATA[15:0];
//	  LOCAL_REG[AVL_ADDR][23:16]<=AVL_WRITEDATA[23:16];
//	  end
//	  if(AVL_BYTE_EN==4'b0110)
//	  begin
//	  LOCAL_REG[AVL_ADDR][15:8]<=AVL_WRITEDATA[15:8];
//	  LOCAL_REG[AVL_ADDR][23:16]<=AVL_WRITEDATA[23:16];
//	  end
//	end
//	
//	else if(AVL_CS&&AVL_READ)
//	AVL_READDATA[31:0]<=LOCAL_REG[AVL_ADDR][31:0];
//	
	/*begin
	  if(AVL_BYTE_EN==4'b1111)
	  
	  if(AVL_BYTE_EN==4'b0001)
	  AVL_READDATA[7:0]<=LOCAL_REG[AVL_ADDR][7:0];
	  if(AVL_BYTE_EN==4'b0010)
	  AVL_READDATA[15:8]<=LOCAL_REG[AVL_ADDR][15:8];
	  if(AVL_BYTE_EN==4'b0100)
	  AVL_READDATA[23:16]<=LOCAL_REG[AVL_ADDR][23:16];
	  if(AVL_BYTE_EN==4'b1000)
	  AVL_READDATA[31:24]<=LOCAL_REG[AVL_ADDR][31:24];
	  if(AVL_BYTE_EN==4'b0011)
	  AVL_READDATA[15:0]<=LOCAL_REG[AVL_ADDR][15:0];
	  if(AVL_BYTE_EN==4'b1100)
	  AVL_READDATA[31:16]<=LOCAL_REG[AVL_ADDR][31:16];
	  if(AVL_BYTE_EN==4'b1110)
	  begin
	  AVL_READDATA[31:16]<=LOCAL_REG[AVL_ADDR][31:16];
	  AVL_READDATA[15:8]<=LOCAL_REG[AVL_ADDR][15:8];
	  end
	  if(AVL_BYTE_EN==4'b0111)
	  begin
	  AVL_READDATA[15:0]<=LOCAL_REG[AVL_ADDR][15:0];
	  AVL_READDATA[23:16]<=LOCAL_REG[AVL_ADDR][23:16];
	  end
	  if(AVL_BYTE_EN==4'b0110)
	  begin
	  AVL_READDATA[15:8]<=LOCAL_REG[AVL_ADDR][15:8];
	  AVL_READDATA[23:16]<=LOCAL_REG[AVL_ADDR][23:16];
	  end*/
	  
	//end
end


//handle drawing (may either be combinational or sequential - or both).
		

endmodule
