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
`define NUM_REGS 8 //80*30 characters / 4 characters per register
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
	input  logic [11:0] AVL_ADDR,			// Avalon-MM Address
	input  logic [31:0] AVL_WRITEDATA,		// Avalon-MM Write Data
	output logic [31:0] AVL_READDATA,		// Avalon-MM Read Data
	
	// Exported Conduit (mapped to VGA port - make sure you export in Platform Designer)
	output logic [3:0]  red, green, blue,	// VGA color channels (mapped to output pins in top-level)
	output logic hs, vs						// VGA HS/VS
);

logic [31:0] LOCAL_REG [`NUM_REGS]; // Registers
//put other local variables here
logic PIXEL_CLK;
logic BLANK;
logic SYNC;
logic [9:0] DRAWX, DRAWY;
logic [10:0] ADDR;
logic [7:0] DATA;
logic [11:0] BA;
logic [9:0] WA;
logic [31:0] CharID;
logic [7:0] SpecID;
logic SpecADDR;

//Declare submodules..e.g. VGA controller, ROMS, etc
vga_controller vc (.Clk(CLK),
                   .Reset(RESET),
                   .hs(hs),
						 .vs(vs),
						 .pixel_clk(PIXEL_CLK),
						 .blank(BLANK),
						 .sync(SYNC),
						 .DrawX(DRAWX),
						 .DrawY(DRAWY));

font_rom fr (.addr(ADDR),
				 .data(DATA));
				 
			 
//logic [15:0] ST1, ST0;
logic IV1, IV0;
logic [6:0] CODE1, CODE0;
logic [3:0] FGD_IDX1, FGD_IDX0;
logic [3:0] BKG_IDX1, BKG_IDX0;

mem mem1(.address_a(AVL_ADDR),
	.address_b(WA),
	.clock(CLK),
	.data_a(AVL_WRITEDATA),
	.data_b(),
	.wren_a(AVL_WRITE && AVL_CS),
	.wren_b(),
	.q_a(CharID),
	.q_b());
				 
				 
//always_ff @(posedge CLK)
//begin
		
				 
	
   
// Read and write from AVL interface to register block, note that READ waitstate = 1, so this should be in always_ff
//always_ff @(posedge CLK) 
//begin
//	if (RESET)
//		LOCAL_REG [AVL_ADDR] <= 32'h0;
//	else if (AVL_WRITE && AVL_CS) begin
//		if (AVL_BYTE_EN[0])
//		LOCAL_REG [AVL_ADDR] [7:0] <= AVL_WRITEDATA[7:0];
//		if (AVL_BYTE_EN[1])
//		LOCAL_REG [AVL_ADDR] [15:8] <= AVL_WRITEDATA[15:8];
//		if (AVL_BYTE_EN[2])
//		LOCAL_REG [AVL_ADDR] [23:16] <= AVL_WRITEDATA[23:16];
//		if (AVL_BYTE_EN[3])
//		LOCAL_REG [AVL_ADDR] [31:24] <= AVL_WRITEDATA[31:24];
//	end
//	else if (AVL_READ && AVL_CS) begin
//		AVL_READDATA <= LOCAL_REG [AVL_ADDR];
//	end
//end

//handle drawing (may either be combinational or sequential - or both).

always_comb
begin
	BA = DRAWY[9:4] * 80 + DRAWX[9:3];
	WA = BA[11:2];
	//CharID = LOCAL_REG [WA];
	//always_comb
	begin
		case(BA[1:0])
			2'b00    :    SpecID = CharID[7:0];
			2'b01    :    SpecID = CharID[15:8];
			2'b10    :    SpecID = CharID[23:16];
			2'b11    :    SpecID = CharID[31:24];
		endcase
	end
	ADDR <= {SpecID[6:0], DRAWY[3:0]};
	//always_comb
	begin
		case(DRAWX[2:0])
			3'b000    :    SpecADDR = DATA[7];
			3'b001    :    SpecADDR = DATA[6];
			3'b010    :    SpecADDR = DATA[5];
			3'b011    :    SpecADDR = DATA[4];
			3'b100    :    SpecADDR = DATA[3];
			3'b101    :    SpecADDR = DATA[2];
			3'b110    :    SpecADDR = DATA[1];
			3'b111    :    SpecADDR = DATA[0];
		endcase
	end
	//always_comb
//	begin
//		case(SpecID[7])
//			1'b0    :    SpecADDR = SpecADDR;
//			1'b1    :    SpecADDR = ~SpecADDR;
//		endcase
//	end
	if (BLANK)
		//always_comb
		begin
			case(SpecADDR^SpecID[7])
				1'b0    :    begin
									red = LOCAL_REG [600] [12:9];
									green = LOCAL_REG [600] [8:5];
									blue = LOCAL_REG [600] [4:1];
								 end
				1'b1    :    begin
									red = LOCAL_REG [600] [24:21];
									green = LOCAL_REG [600] [20:17];
									blue = LOCAL_REG [600] [16:13];
								 end
			endcase
		end
		
	else
		begin
		   red = 4'b0;
			green = 4'b0;
			blue = 4'b0;
		end
end
		

endmodule
