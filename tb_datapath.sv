module tb_datapath(output err);
  reg sim_clk;
  reg [15:0] sim_datapath_in;
  reg sim_wb_sel;
  reg [2:0] sim_w_addr;
  reg sim_w_en;
  reg [2:0] sim_r_addr;
  reg sim_en_A;
  reg sim_en_B;
  reg [1:0] sim_shift_op;
  reg sim_sel_A;
  reg sim_sel_B;
  reg [1:0] sim_ALU_op;
  reg sim_en_C;
  reg sim_en_status;
  reg [15:0] sim_datapath_out;
  reg sim_Z_out;
  reg er;
  assign err = er;

  integer numTests = 0;
  integer shiftOp_index = 0;
  integer aluOp_index = 0;
  integer testsFailed = 0;
  const integer numOps = 4;

  reg [1:0]shiftOp[3:0] = {2'b00, 2'b01, 2'b10, 2'b11};
  reg [1:0]aluOp[3:0] = {2'b00, 2'b01, 2'b10, 2'b11};

  reg [15:0]expectedALU[15:0] = {16'd17, 16'd1, 16'd8, 16'b1111111111110111, 16'd25, -16'd7, 16'd0, 16'b1111111111101111, 16'd13, 16'd5, 16'd0, 16'b1111111111111011, 16'd13, 16'd5, 16'd0, 16'b1111111111111011};


  //tasks
  task pressClk();
    begin
      sim_clk = 1'b1;
      #20;
      sim_clk = 1'b0;
      #20;
    end
  endtask
  task error();
    begin
      er = 1'b1;
      #20;
      er = 1'b0;
      #20;
    end
  endtask
  task enableA();
    begin
      sim_en_A = 1'b1;
      #20;
    end
  endtask
  task disableA();
    begin
      sim_en_A = 1'b0;
      #20;
    end
  endtask
  task enableB();
    begin
      sim_en_B = 1'b1;
      #20;
    end
  endtask
  task disableB();
    begin
      sim_en_B = 1'b0;
      #20;
    end
  endtask
  task enableC();
    begin
      sim_en_C = 1'b1;
      #20;
    end
  endtask
  task disableC();
    begin
      sim_en_C = 1'b0;
      #20;
    end
  endtask
  task enableWrite();
    begin
    sim_w_en = 1'b1;
    #20;
    end
  endtask

  task disableWrite();
    begin
      sim_w_en = 1'b0;
      #20;
    end
  endtask

  datapath DUT(.clk(sim_clk), .datapath_in(sim_datapath_in), .wb_sel(sim_wb_sel),
                .w_addr(sim_w_addr), .w_en(sim_w_en), .r_addr(sim_r_addr), .en_A(sim_en_A),
                .en_B(sim_en_B), .shift_op(sim_shift_op), .sel_A(sim_sel_A), .sel_B(sim_sel_B),
                .ALU_op(sim_ALU_op), .en_C(sim_en_C), .en_status(sim_en_status),
                .datapath_out(sim_datapath_out), .Z_out(sim_Z_out));
  initial begin
    enableWrite();
    sim_datapath_in = 16'd9;
    sim_wb_sel = 1'b1;
    sim_w_addr = 2'd0;
    pressClk();
    sim_w_addr = 2'd1;
    sim_datapath_in = 16'd8;
    pressClk();
    disableWrite();
    disableB();
    enableA();
    sim_r_addr = 2'd0;
    pressClk();
    disableA();
    enableB();
    sim_r_addr = 2'd1;
    pressClk();
    sim_sel_A = 1'b1;
    sim_sel_B = 1'b0;
    enableC();
    sim_shift_op = 2'b00;
    sim_ALU_op = 2'b00;

    #50;

    pressClk();
    numTests = numTests + 1;
    assert(sim_datapath_out === 16'd8)
    $display("Datapath functioning as expected when sel A is 1!");
    else begin
      error();
      testsFailed = testsFailed + 1;
      $error("ERROR: Datapath not functioning as expected when sel A is 1");
    end 
    sim_sel_A = 1'b0;
    sim_sel_B = 1'b1;
    enableC();
    sim_shift_op = 2'b00;
    sim_ALU_op = 2'b00;
    #50;
    pressClk();
    numTests = numTests + 1;
    assert(sim_datapath_out === 16'd17)
    $display("Datapath functioning as expected when sel A is 1!");
    else begin
      error();
      testsFailed = testsFailed + 1;
      $error("ERROR: Datapath not functioning as expected when sel A is 1");
    end 
    sim_sel_A = 1'b0;
    sim_sel_B = 1'b0;
    for(shiftOp_index = 0; shiftOp_index < numOps; shiftOp_index = shiftOp_index + 1) begin
      sim_shift_op = shiftOp[shiftOp_index];
      #50;
      for(aluOp_index = 0; aluOp_index < numOps; aluOp_index = aluOp_index + 1) begin
        enableC();
        sim_ALU_op = aluOp[aluOp_index];
        #50;
        pressClk();
        numTests = numTests + 1;
        assert(sim_datapath_out === expectedALU[4*shiftOp_index + aluOp_index])
        $display("Datapath functioning as expected!");
        else begin
          error();
          testsFailed = testsFailed + 1;
          $error("ERROR: Datapath not functioning as expected");
        end 
      end


    end

      
    $strobe("Failed %f tests out of %f", testsFailed, numTests);
  end

endmodule: tb_datapath
