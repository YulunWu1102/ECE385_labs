module testbench();

timeunit 10ns;	// Half clock cycle at 50 MHz
			// This is the amount of time represented by #1 
timeprecision 1ns;

// These signals are internal because the processor will be 
// instantiated as a submodule in testbench.
logic Clk = 0;
logic   Reset, Execute;
logic [7:0]  Din;
logic [6:0]  AhexL,
				 AhexU,
				 BhexL,
				 BhexU;
logic [3:0]  LED;
logic [7:0] Aval,
				Bval;
logic B0val;
logic [8:0] S_outval, A_exval, S_exval;


// To store expected results
//logic [7:0] ans_1a, ans_2b;
				
// A counter to count the instances where simulation results
// do no match with expected results
//integer ErrorCnt = 0;
		
// Instantiating the DUT
// Make sure the module and signal names match with those in your design
Multiplier multiplier0(.*);	

// Toggle the clock
// #1 means wait for a delay of 1 timeunit
always begin : CLOCK_GENERATION
#1 Clk = ~Clk;
end

initial begin: CLOCK_INITIALIZATION
    Clk = 0;
end 

// Testing begins here
// The initial block is not synthesizable
// Everything happens sequentially inside an initial block
// as in a software program
initial begin: TEST_VECTORS
Reset = 0;		// Toggle Rest
Execute = 0;
Din = 8'h04;	// Specify Din, F, and R


#2 Reset = 1;

#2 Din = 8'h02;	// Change Din
#2 Execute = 1;	// Toggle Execute
   

#22 Execute = 0;
 
end
endmodule
