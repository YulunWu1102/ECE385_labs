module testbench_mux();

timeunit 10ns;

timeprecision 1ns;

logic Clk;
logic  F_21;
logic [15:0] A_In, B_In;
logic [15:0] MUX_21_OUT;
assign A_In = 16'b0000000000000000;
assign B_In = 16'b1111111111111111;



mux21_test MUX_21(.*);

always begin : CLOCK_GENERATION
#1 Clk = ~Clk;
end

initial begin: CLOCK_INITIALIZATION
    Clk = 0;
end 

initial begin: TEST_VECTORSs
	#0 F_21 = 1'b1;
	
	#2 F_21 = 1'b0;
	 
	#2 F_21 = 1'b1;

	
end

endmodule
