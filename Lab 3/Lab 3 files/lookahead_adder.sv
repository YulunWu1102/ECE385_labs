module lookahead_adder (
	input  [15:0] A, B,
	input         cin,
	output [15:0] S,
	output        cout
);
    /* TODO
     *
     * Insert code here to implement a CLA adder.
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */
		logic G0, G4, G8, G12, P0, P4, P8, P12, C0, C4, C8, C12;
		
		assign C0 = cin;
		CLA_4 CLA1 (.A_4(A[3:0]), .B_4(B[3:0]), .c_in_4(C0), .s_4(S[3:0]), .G_out(G0), .P_out(P0));
		
		assign C4 = G0 | (C0 & P0);
		CLA_4 CLA2 (.A_4(A[7:4]), .B_4(B[7:4]), .c_in_4(C4), .s_4(S[7:4]), .G_out(G4), .P_out(P4));
		
		assign C8 = G4 | (G0 & P4) | (C0 & P4 &P0);
		CLA_4 CLA3 (.A_4(A[11:8]), .B_4(B[11:8]), .c_in_4(C8), .s_4(S[11:8]), .G_out(G8), .P_out(P8));
		
		assign C12 = (G8) | (G4 & P8) | (G0 & P8 & P4) | (C0 & P8 & P4 &P0);
		CLA_4 CLA4 (.A_4(A[15:12]), .B_4(B[15:12]), .c_in_4(C12), .s_4(S[15:12]), .G_out(G12), .P_out(P12));
		
		assign cout = G12 | (G8 & P12) | (G4 & P12 & P8) | (G0 & P12 & P8 & P4) | (C0 & P12 & P8 & P4 &P0);
		
	  
	  
endmodule
