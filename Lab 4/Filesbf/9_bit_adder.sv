module Nine_Bit_Adder
(
 input  [7:0] S, A,
 input         fn, B0,
 output [8:0] S_out,
 output [8:0] A_exval,
 output [8:0] S_exval//debug
);

    /* TODO
     *
     * Insert code here to implement a ripple adder.
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */
  logic c1, c2, c3;
  
  logic [8:0] S_ex0, S_ex, A_ex;
  logic [7:0] inverter, B0_array;
  
	
  assign B0_array[0]=B0; 
  assign B0_array[1]=B0;  
  assign B0_array[2]=B0;
  assign B0_array[3]=B0; 
  assign B0_array[4]=B0;  
  assign B0_array[5]=B0;
  assign B0_array[6]=B0; 
  assign B0_array[7]=B0;  
 
  assign A_ex[7:0] = A;
  assign A_ex[8] = A_ex[7];
  assign A_exval = A_ex;

  
  assign inverter[0]=fn; 
  assign inverter[1]=fn;  
  assign inverter[2]=fn;  
  assign inverter[3]=fn;  
  assign inverter[4]=fn;  
  assign inverter[5]=fn;  
  assign inverter[6]=fn;  
  assign inverter[7]=fn; 
  
  
  assign S_ex0[7:0] = S & B0_array;
  assign S_ex[7:0] = (S_ex0 ^ inverter);
  assign S_ex[8] = S_ex[7];
  assign S_exval = S_ex;

  
  
   ADDER9 Call_ADDER9 (.S_ex(S_ex), .A_ex(A_ex), .fn(fn), .S_out(S_out));
  

     
endmodule