module MDR_ (input logic Clk, LD_MDR,
              input  logic [15:0]  MDR_In,
              output logic [15:0]  MDR);


reg_16 mdr_reg (.Clk(Clk), .Reset(1'b0), .Load(LD_MDR), .Data_In(MDR_In), .Data_Out(MDR));


endmodule