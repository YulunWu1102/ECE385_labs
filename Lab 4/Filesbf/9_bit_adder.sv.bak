module ripple_adder
(
	input  [15:0] A, B,
	input         cin,
	output [15:0] S,
	output        cout
);

    /* TODO
     *
     * Insert code here to implement a ripple adder.
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */
		logic c1, c2, c3;
		
		ADDER4 FA0 (.A_4(A[3:0]), .B_4(B[3:0]), .c_in_4(cin), .S_4(S[3:0]), .c_out_4(c1));
		ADDER4 FA1 (.A_4(A[7:4]), .B_4(B[7:4]), .c_in_4(c1), .S_4(S[7:4]), .c_out_4(c2));
		ADDER4 FA2 (.A_4(A[11:8]), .B_4(B[11:8]), .c_in_4(c2), .S_4(S[11:8]), .c_out_4(c3));
		ADDER4 FA3 (.A_4(A[15:12]), .B_4(B[15:12]), .c_in_4(c3), .S_4(S[15:12]), .c_out_4(cout));
 
     
endmodule
