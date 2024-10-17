module tb_ALU(output err);
  reg [15:0] sim_val_A;
  reg [15:0] sim_val_B;
  reg [1:0] sim_ALU_op;
  reg [15:0] sim_ALU_out;
  reg sim_Z;
  reg er;
  const integer numCases = 3;
  integer index;
  integer numTest = 0;
  integer testFailed = 0;
  //values for A
  reg [15:0]valA[2:0] = {16'd0, 16'd10, 16'd13};
  //values for B
  reg [15:0]valB[2:0] = {16'd0, 16'd11, 16'd4};
  //output values for addition
  reg [15:0]additionResults[2:0] = {16'd0, 16'd21, 16'd17};
  //output values for subtraction
  reg [15:0]subtractionResults[2:0] = {16'd0, -16'd1, 16'd9};
  //output values for bitwiseAnd
  reg [15:0]bitwiseAND_results[2:0] = {16'd0, 16'd10, 16'd4};
  //output values for bitwise Negation
  reg [15:0]bitwiseNEG_results[2:0] = {16'b1111111111111111, 16'b1111111111110100, 16'b1111111111111011};
  // putput values for Z flag
  reg zFlag[2:0] = {1'b1, 1'b0, 1'b0};

  assign err = er;
  task error();
    begin
      er = 1'b1;
      #20;
      er = 1'b0;
      #20;
    end
  endtask
  task addition();
    begin
      sim_ALU_op = 2'b00;
      #20;
    end
  endtask

  task subtraction();
    begin
      sim_ALU_op = 2'b01;
      #20;
    end
  endtask

  task bitwiseAND();
    begin
      sim_ALU_op = 2'b10;
      #20;
    end
  endtask

  task bitwiseNEG();
    begin
      sim_ALU_op = 2'b11;
      #20;
    end
  endtask
  ALU DUT(.val_A(sim_val_A), .val_B(sim_val_B), .ALU_op(sim_ALU_op), .ALU_out(sim_ALU_out), .Z(sim_Z));
//  My testing procedure is as follows:
//    I will select 3 pairs of numbers and for each pair check all 3 operations
  initial begin
  for(index = 0; index < numCases; index = index +1) begin
    sim_val_A = valA[index];
    sim_val_B = valB[index];
    addition();

    numTest = numTest + 1;
    assert(sim_ALU_out === additionResults[index])
    $display("Addition functioning as expected!");
    else begin
      error();
      testFailed = testFailed + 1;
      $error("ERROR: Addition not functioning as expected");
    end 
    numTest = numTest + 1;
    assert(sim_Z === zFlag[index])
    $display("Z flag functioning as expected with addition!");
    else begin
      error();
      testFailed = testFailed + 1;
      $error("ERROR: Z flag not functioning as expected with addition");
    end   

    subtraction();
    numTest = numTest + 1;
    assert(sim_ALU_out === subtractionResults[index])
    $display("Subtraction functioning as expected!");
    else begin
      error();
      testFailed = testFailed + 1;
      $error("ERROR: Subtraction not functioning as expected");
    end 
    numTest = numTest + 1;
    assert(sim_Z === zFlag[index])
    $display("Z flag functioning as expected with subtraction!");
    else begin
      error();
      testFailed = testFailed + 1;
      $error("ERROR: Z flag not functioning as expected with subtraction");
    end

    bitwiseAND();
    numTest = numTest + 1;
    assert(sim_ALU_out === bitwiseAND_results[index])
    $display("Bitwise AND functioning as expected!");
    else begin
      error();
      testFailed = testFailed + 1;
      $error("ERROR: Bitwise AND not functioning as expected");
    end 
    numTest = numTest + 1;
    assert(sim_Z === zFlag[index])
    $display("Z flag functioning as expected with Bitwise AND!");
    else begin
      error();
      testFailed = testFailed + 1;
      $error("ERROR: Z flag not functioning as expected with Bitwise AND");
    end

    bitwiseNEG();
    numTest = numTest + 1;
    assert(sim_ALU_out === bitwiseNEG_results[index])
    $display("Bitwise NEG functioning as expected!");
    else begin
      error();
      testFailed = testFailed + 1;
      $error("ERROR: Bitwise NEG not functioning as expected");
    end 
    numTest = numTest + 1;
    assert(sim_Z === 1'b0)
    $display("Z flag functioning as expected with Bitwise NEG!");
    else begin
      error();
      testFailed = testFailed + 1;
      $error("ERROR: Z flag not functioning as expected with Bitwise NEG");
    end
  end

    $strobe("Failed %f tests out of %f", testFailed, numTest);
  end

endmodule: tb_ALU
