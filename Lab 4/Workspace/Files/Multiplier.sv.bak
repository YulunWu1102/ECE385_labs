//4-bit logic processor top level module
//for use with ECE 385 Spring 2021
//last modified by Zuofu Cheng


//Always use input/output logic types when possible, prevents issues with tools that have strict type enforcement

module Processor (input logic   Clk,     // Internal
                                Reset,   // Push button 0
                                Execute, // Push button 3
                  input  logic [7:0]  Din,     // through switch               
                  output logic [6:0]  AhexL,
                                AhexU,
                                BhexL,
                                BhexU);

	 //local logic variables go here

	 logic [7:0] A, B;
	 logic Shift_En_, Load_, Subtract_;
	 
	 

		
	 
	 //Instantiation of modules here
	 register_unit    reg_unit (
                        .Clk(Clk),
                        .Reset(Reset_SH),
                        .Ld_A, //note these are inferred assignments, because of the existence a logic variable of the same name
                        .Ld_B,
                        .Shift_En,
                        .D(Din_S),
                        .A_In(newA),
                        .B_In(newB),
                        .A_out(opA),
                        .B_out(opB),
                        .A(A),
                        .B(B) );
    compute          compute_unit (
								.F(F_S),
                        .A_In(opA),
                        .B_In(opB),
                        .A_Out(bitA),
                        .B_Out(bitB),
                        .F_A_B );
    router           router (
								.R(R_S),
                        .A_In(bitA),
                        .B_In(bitB),
                        .A_Out(newA),
                        .B_Out(newB),
                        .F_A_B );
	 
	 control (.Clk(Clk), .Reset(Reset), .Execute(Execute),
                output logic Shift_En, Load, Subtract);
	 
	 control          control_unit (
                        .Clk(Clk),
                        .Reset(Reset_SH),
                        .LoadA(LoadA_SH),
                        .LoadB(LoadB_SH),
                        .Execute(Execute_SH),
                        .Shift_En,
                        .Ld_A,
                        .Ld_B );
								
								
		//2.16 update						
		HexDriver		AHex0 (
								.In0(A[3:0]),
								.Out0(HEX0) );
								
		HexDriver		AHex1 (
								.In0(A[7:4]),
								.Out0(HEX1) );
								
		HexDriver		BHex0 (
								.In0(B[3:0]),
								.Out0(HEX2) );
								
		HexDriver		BHex1 (
								.In0(B[7:4]),
								.Out0(HEX3) );
		
								
		
								
	  //Input synchronizers required for asynchronous inputs (in this case, from the switches)
	  //These are array module instantiations
	  //Note: S stands for SYNCHRONIZED, H stands for active HIGH
	  //Note: We can invert the levels inside the port assignments
	  sync button_sync[3:0] (Clk, {~Reset, LoadA, LoadB, ~Execute}, {Reset_SH, LoadA_SH, LoadB_SH, Execute_SH});
	  sync Din_sync[7:0] (Clk, Din, Din_S);
	  sync F_sync[2:0] (Clk, F, F_S);
	  sync R_sync[1:0] (Clk, R, R_S);
	  
endmodule
