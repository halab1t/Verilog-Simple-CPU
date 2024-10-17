module datapath(input clk, input [15:0] datapath_in, input wb_sel,
                input [2:0] w_addr, input w_en, input [2:0] r_addr, input en_A,
                input en_B, input [1:0] shift_op, input sel_A, input sel_B,
                input [1:0] ALU_op, input en_C, input en_status,
                output [15:0] datapath_out, output Z_out);
  
  wire [15:0] actual_w_data;
  wire [15:0] actual_val_A;
  wire [15:0] actual_val_B;
  wire [15:0] actual_r_data;
  wire [15:0] actual_shift_out;
  wire [15:0] actual_alu_out;
  wire z_flag;

  reg [15:0] register_A;
  reg [15:0] register_B;
  reg [15:0] register_C;
  reg status_reg;

  assign datapath_out = register_C;
  assign actual_w_data = wb_sel? datapath_in : datapath_out;
  assign actual_val_A = sel_A? 16'd0 : register_A;
  assign actual_val_B = sel_B? {11'd0, datapath_in[4:0]} : actual_shift_out;
  assign Z_out = status_reg;



  regfile actual_registerFile(.w_data(actual_w_data), .w_addr(w_addr), .w_en(w_en), .r_addr(r_addr), .clk(clk), .r_data(actual_r_data));
  ALU actual_alu(.val_A(actual_val_A), .val_B(actual_val_B), .ALU_op(ALU_op), .ALU_out(actual_alu_out), .Z(z_flag));
  shifter actual_shifter(.shift_in(register_B), .shift_op(shift_op), .shift_out(actual_shift_out));

  always_ff @(posedge clk) 
  begin
    if (en_A) begin
      register_A <= actual_r_data;
    end
    if (en_B) begin
      register_B <= actual_r_data;
    end
    if (en_C) begin
      register_C <= actual_alu_out;
    end
    if (en_status) begin
      status_reg <= z_flag;
    end
  end


  
endmodule: datapath
