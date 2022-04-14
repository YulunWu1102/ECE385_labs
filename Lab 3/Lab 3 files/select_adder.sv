module select_adder (
	input  [15:0] A, B,
	input         cin,
	output [15:0] S,
	output        cout
);

    /* TODO
     *
     * Insert code here to implement a CSA adder.
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */
	  
	  logic C4, C8, C12;
	  

	  
	  ADDER4 FA0 (.A_4(A[3:0]), .B_4(B[3:0]), .c_in_4(cin), .S_4(S[3:0]), .c_out_4(C4));
	  CS     CS1 (.A_4(A[7:4]), .B_4(B[7:4]), .c_in(C4),  .s_4(S[7:4]), .c_out(C8));
	  CS     CS2 (.A_4(A[11:8]), .B_4(B[11:8]), .c_in(C8),  .s_4(S[11:8]), .c_out(C12));
	  CS     CS3 (.A_4(A[15:12]), .B_4(B[15:12]), .c_in(C12),  .s_4(S[15:12]), .c_out(cout));
	  
endmodule
