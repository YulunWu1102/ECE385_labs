module full_adder (input x,y,z,
						output s,c		);
		assign s = x^y^z;
		assign c = (x&y)|(y&z)|(x&z);
endmodule





module ADDER9(input	[8:0] S_ex, A_ex,
				  input 				fn,
				  output	[8:0] S_out);
				  
logic			c1, c2, c3, c4, c5, c6, c7, c8, c9;

full_adder FA0 (.x(S_ex[0]), .y(A_ex[0]), .z(fn), .s(S_out[0]), .c(c1));
full_adder FA1 (.x(S_ex[1]), .y(A_ex[1]), .z(c1), .s(S_out[1]), .c(c2));
full_adder FA2 (.x(S_ex[2]), .y(A_ex[2]), .z(c2), .s(S_out[2]), .c(c3));
full_adder FA3 (.x(S_ex[3]), .y(A_ex[3]), .z(c3), .s(S_out[3]), .c(c4));
full_adder FA4 (.x(S_ex[4]), .y(A_ex[4]), .z(c4), .s(S_out[4]), .c(c5));
full_adder FA5 (.x(S_ex[5]), .y(A_ex[5]), .z(c5), .s(S_out[5]), .c(c6));
full_adder FA6 (.x(S_ex[6]), .y(A_ex[6]), .z(c6), .s(S_out[6]), .c(c7));
full_adder FA7 (.x(S_ex[7]), .y(A_ex[7]), .z(c7), .s(S_out[7]), .c(c8));
full_adder FA8 (.x(S_ex[8]), .y(A_ex[8]), .z(c8), .s(S_out[8]), .c(c9));


endmodule
