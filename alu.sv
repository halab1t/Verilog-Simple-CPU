module ALU(input [15:0] val_A, input [15:0] val_B, input [1:0] ALU_op, output [15:0] ALU_out, output Z);
  reg [15:0] result;
  reg zFlag;
  assign ALU_out = result;
  assign Z = zFlag;
  always_comb begin
    case(ALU_op)
      2'b00: result = val_A + val_B;
      2'b01: result = val_A - val_B;
      2'b10: result = val_A & val_B;
      2'b11: result = ~val_B;
    endcase
  end

  always @(result) begin
    case(result)
      16'd0: zFlag <= 1'b1;
      default: zFlag <= 1'b0;
    endcase
  end

endmodule: ALU
