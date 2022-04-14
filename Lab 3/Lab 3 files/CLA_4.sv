//module single_CLA (input a, b, c_in_1.
//						 output s, c_out_1);
//		assign g = a&b;
//		assign p = a^b;
//		assign s = a^b^c_in_1;

//endmodule


module CLA_4(input	[3:0] A_4, B_4,
				 input 			  c_in_4,
				 output	[3:0] 	  s_4,
				 output	  G_out, P_out);
				 
		logic p0, p1, p2, p3,
				g0, g1, g2, g3,
				c1, c2, c3;
				
		always_comb
		begin: cla_4
			p0 = A_4[0] ^ B_4[0];
			p1 = A_4[1] ^ B_4[1];
			p2 = A_4[2] ^ B_4[2];
			p3 = A_4[3] ^ B_4[3];
			
			g0 = A_4[0] & B_4[0];
			g1 = A_4[1] & B_4[1];
			g2 = A_4[2] & B_4[2];
			g3 = A_4[3] & B_4[3];
			
			
			c1 = (c_in_4 & p0) | g0;
			c2 = (c_in_4 & p0 & p1) | (g0 & p1) | (g1);
			c3 = (c_in_4 & p0 & p1 & p2) | (g0 & p1 & p2) | (g1 & p2) | g2;
			
			
			s_4[0] = A_4[0]^B_4[0]^c_in_4;
			s_4[1] = A_4[1]^B_4[1]^c1;
			s_4[2] = A_4[2]^B_4[2]^c2;
			s_4[3] = A_4[3]^B_4[3]^c3;
			
			P_out = p0&p1&p2&p3;
			G_out = g3 | (g2&p3)|(g1&p3&p2)|(g0&p3&p2&p1);
			
		end: cla_4
			
		endmodule



		