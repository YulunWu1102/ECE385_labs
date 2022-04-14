//4-bit logic processor top level module
//for use with ECE 385 Spring 2021
//last modified by Zuofu Cheng


//Always use input/output logic types when possible, prevents issues with tools that have strict type enforcement

module Multiplier (input logic   Clk,     // Internal
                                Reset,   // Push button 0
                                Execute, // Push button 3
                  input  logic [7:0]  Din,     // through switch               
                  output logic [6:0]  AhexL,
                                AhexU,
                                BhexL,
                                BhexU,
						output logic [7:0]  Aval,    // DEBUG
                                Bval,    // DEBUG
						output logic [3:0] LED,
						output logic B0val,
						output logic [8:0] S_outval,
						output logic [8:0] A_exval, S_exval);

	 //local logic variables go here

	 logic [7:0] A, B, Din_S;//registers
	 logic [8:0] S_out;
	 logic Reset_SH, Execute_SH; //synced button
	 logic Shift_En, Load, Subtract, B0, Load_B;
	 logic Shift_In_A, Shift_En_A, Shift_Out_A, Reset_B; //useless-variables
	 assign Reset_B = 1'b0;
	 assign Shift_In_A = 1'b0;
	 assign Shift_En_A = 1'b0;
	 assign Load_B 	 = Reset_SH;//whenever reset button is pushed, RegB load value from Din
	 //debug array
	 assign LED[0] = Load;
	 assign LED[1] = Reset_SH;
	 assign LED[2] = Execute_SH;
	 assign LED[3] = Load_B;
	 assign Aval = A;
	 assign Bval = B;
	 assign B0val = B0;
	 assign S_outval = S_out;
	 
	 
	 //Input synchronizers required for asynchronous inputs (in this case, from the switches)
	  //These are array module instantiations
	  //Note: S stands for SYNCHRONIZED, H stands for active HIGH
	  //Note: We can invert the levels inside the port assignments
	  sync button_sync[1:0] (Clk, {~Reset, ~Execute}, {Reset_SH, Execute_SH});
	  sync Din_sync[7:0] (Clk, Din, Din_S);
	  

		
	 
	 //Instantiation of modules here
		control         CONTROL (
                        .Clk(Clk),
                        .Reset(Reset_SH),
                        .Execute(Execute_SH),
                        .Shift_En,
                        .Load,
                        .Subtract );
						
		Nine_Bit_Adder		ADDER(
								.S(Din_S),
								.A,
								.fn(Subtract),
								.B0,
								.S_out,
								.A_exval,
								.S_exval);
								
	 
	 
		reg_8			     Reg_A (
								.Clk(Clk),
								.Reset(Reset_SH),
								.Shift_In(Shift_In_A),		//useless variable, never shift
								.Load,							//same with output from control
								.Shift_En(Shift_En_A),		//useless variable, never shift
								.Data_In(S_out[8:1]),
								.Shift_Out(Shift_Out_A),	//useless variable
								.Data_Out(A));
								
		reg_8			     Reg_B (
								.Clk(Clk),
								.Reset(Reset_B),
								.Shift_In(S_out[0]),
								.Load(Load_B),					//reverse with reset A
								.Shift_En,						//control
								.Data_In(Din_S),
								.Shift_Out(B0),				//detect the last bit
								.Data_Out(B));
								
								 
								
								
		//2.16 update						
		HexDriver		AHex0 (
								.In0(A[3:0]),
								.Out0(AhexL) );
								
		HexDriver		AHex1 (
								.In0(A[7:4]),
								.Out0(AhexU) );
								
		HexDriver		BHex0 (
								.In0(B[3:0]),
								.Out0(BhexL) );
								
		HexDriver		BHex1 (
								.In0(B[7:4]),
								.Out0(BhexU) );
		
								
		
								
	  
	  
endmodule
