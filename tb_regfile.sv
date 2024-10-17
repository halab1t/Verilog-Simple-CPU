module tb_regfile(output err);
    reg [2:0] sim_w_addr;
    reg [2:0] sim_r_addr;
    reg [15:0] sim_w_data;
    reg [15:0] sim_r_data;
    reg sim_clk;
    reg sim_w_en;
    reg er;
    assign err = er;
    integer testsFailed = 0;
    integer numTests = 0;
    reg [2:0]regVals[7:0] = {3'd0, 3'd1, 3'd2, 3'd3, 3'd4, 3'd5, 3'd6, 3'd7};
    integer regNum;
    const integer numReg = 8;

    task error();
      begin
        er = 1'b1;
        #20;
        er = 1'b0;
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
    task clockPress();
      begin 
        sim_clk = 1'b1;
        #20;
        sim_clk = 1'b0;
        #20;
      end
    endtask
    regfile DUT(.w_data(sim_w_data), .w_addr(sim_w_addr), .w_en(sim_w_en), .r_addr(sim_r_addr), .clk(sim_clk), .r_data(sim_r_data));
//my testing procedure is as follows:
//      I will read the data in each register, then write to the register (check that nothing has happened before pressing the clock), 
//      also check that nothing happens if write is not enabled, then I will enable wrtiting, press the clock, and check that the updated
//      value is being 'read' from that register
    initial begin
//begin by correctly writing to register zero
      sim_r_addr = 3'd0;
      sim_w_addr = 3'd0;
      sim_w_data = 16'd9;
      enableWrite();
      clockPress();

      numTests = numTests + 1;
      assert(sim_r_data === 16'd9)
      $display("Write functioning as expected when enabled and clock pressed");
      else begin
        error();
        testsFailed = testsFailed + 1;
        $error("ERROR: Write not functioning as expected when enabled and clock pressed");
      end
//checking nothing happens when clock isn't pressed
      enableWrite();
      sim_w_addr = 3'd0;
      sim_w_data = 16'd0;
      numTests = numTests + 1;
      assert(sim_r_data === 16'd9)
      $display("Write functioning as expected when enabled and clock not pressed");
      else begin
        error();
        testsFailed = testsFailed + 1;
        $error("ERROR: Write not functioning as expected when enabled and clock not pressed");
      end
//checking nothing happens when write is disabled
      disableWrite();
      sim_w_data = 16'd0;
      clockPress();
      numTests = numTests + 1;
      assert(sim_r_data === 16'd9)
      $display("Write functioning as expected when disabled and clock pressed");
      else begin
        error();
        testsFailed = testsFailed + 1;
        $error("ERROR: Write not functioning as expected when disabled and clock pressed");
      end

//iterating through and reading and writing to all reg values
      for(regNum = 0; regNum < numReg; regNum = regNum +1 )begin
        sim_w_addr = regVals[regNum];
        sim_r_addr = regVals[regNum];
        sim_w_data = regVals[regNum];
        enableWrite();
        clockPress();
        numTests = numTests + 1;
        assert(sim_r_data === regVals[regNum])
        $display("Write functioning as expected when enabled and clock pressed");
        else begin
          error();
          testsFailed = testsFailed + 1;
          $error("ERROR: Write not functioning as expected when enabled and clock pressed");
        end
    end
    $strobe("Failed %f tests out of %f", testsFailed, numTests);
    end
endmodule: tb_regfile
