module full_adder (input x,y,z,
						output s,c		);
		assign s = x^y^z;
		assign c = (x&y)|(y&z)|(x&z);
endmodule



module ADDER4(input	[3:0] A_4, B_4,
				  input 				c_in_4,
				  output	[3:0] S_4,
				  output				c_out_4);
logic			c1, c2, c3;

full_adder FA0 (.x(A_4[0]), .y(B_4[0]), .z(c_in_4), .s(S_4[0]), .c(c1));
full_adder FA1 (.x(A_4[1]), .y(B_4[1]), .z(c1), .s(S_4[1]), .c(c2));
full_adder FA2 (.x(A_4[2]), .y(B_4[2]), .z(c2), .s(S_4[2]), .c(c3));
full_adder FA3 (.x(A_4[3]), .y(B_4[3]), .z(c3), .s(S_4[3]), .c(c_out_4));
endmodule
