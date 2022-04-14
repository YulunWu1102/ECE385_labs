module control (input  logic Clk, Reset, Execute, B7,//2.16 update
					 input  logic [7:0] A_value, //2.16 update
                output logic Shift_En, Load, Subtract, A_CLR);//2.16 update

 enum logic [3:0] {A, B, C, D, E, F,G,H,I, J,K}   curr_state, next_state;
 logic [7:0] B_sign_ext;
	assign B_sign_ext = 8'b00000000;
	

  
     always_ff @ (posedge Clk)  
    begin
          if (Reset)
              curr_state <= A;
          else 
              curr_state <= next_state;
     end

	  
  
always_comb
    begin
	 
    next_state  = curr_state; 
  unique case (curr_state)
            A :    if (Execute)
                       next_state = B;
            B :    next_state = C;
            C :    next_state = D;
            D :    next_state = E;
            E :    next_state = F;
    F :    next_state = G;  
    G :    next_state = H;
            H :    next_state = I;
    I :    next_state = J;
    J :    next_state = K;
    K :    if (~Execute) 
                       next_state = A;
         
        endcase
   
    // Assign outputs based on ‘state’
        case (curr_state) 
        A: 
          begin
  Shift_En = 1'b0;
  Load = 1'b0;
  Subtract = 1'b0;
  A_CLR = 1'b0;
        end
    
    
   B: 
       begin
      Shift_En = 1'b0;
      Load = 1'b0;
      Subtract = 1'b0;
		A_CLR = 1'b1;

           
         end
    
    

        J: 
  begin
  Shift_En = 1'b1;
  Load = 1'b1;
  Subtract = 1'b1;
  A_CLR = 1'b0;


        end
        K: 
  begin
  Shift_En = 1'b0;
  Load = 1'b0;
  Subtract = 1'b0;
	A_CLR = 1'b0;

        end
        default:  
    begin
  Shift_En = 1'b1;
  Load = 1'b1;
  Subtract = 1'b0;
	A_CLR = 1'b0;
        end
        endcase
    end

endmodule
