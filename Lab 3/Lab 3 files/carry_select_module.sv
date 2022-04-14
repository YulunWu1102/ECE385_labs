module CS(input	[3:0] A_4, B_4,
				 input 			    c_in,
				 output	[3:0] 	  s_4,
				 output 				c_out);
				 
				 
				 //assign assumption_0 = 1'b0;
				 //assign assumption_1 = 1'b1;
				 logic [3:0]  S_0, S_1;				 
				 logic 		  c_1, c_0;
				 

				 ADDER4 FA0 (.A_4(A_4[3:0]), .B_4(B_4[3:0]), .c_in_4(1'b0), .S_4(S_0), .c_out_4(c_0));
				 ADDER4 FA1 (.A_4(A_4[3:0]), .B_4(B_4[3:0]), .c_in_4(1'b1), .S_4(S_1), .c_out_4(c_1));
				 
				 assign c_out = (c_in & c_1) | c_0;
				 
//				 if (c_in==1)
//					assign s_4 = S_1;
//				 else
//					assign s_4 = S_0
//				 
				 always_comb
				 begin
					unique case(c_in)
					1'b0: s_4 = S_0;
					1'b1: s_4 = S_1;
					endcase
				 end
endmodule
