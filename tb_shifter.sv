module tb_shifter(output err);
  reg [15:0] sim_shift_in;
  reg [15:0] sim_shift_out;
  reg [1:0] sim_shift_op;
  
  
  reg er;
  const integer numCases = 4;
  integer index;
  integer numTest = 0;
  integer testFailed = 0;
  
  //values for B
  reg [15:0]shiftIn[3:0] = {16'd0, 16'd8, 16'd4, 16'b1100000000000000};
  //output values for no shift
  reg [15:0]noshiftResults[3:0] = {16'd0, 16'd8, 16'd4, 16'b1100000000000000};
  //output values for left shift
  reg [15:0]leftshiftResults[3:0] = {16'd0, 16'd16, 16'd8, 16'b1000000000000000};
  //output values for Right shift
  reg [15:0]rightshiftResults[3:0] = {16'd0, 16'd4, 16'd2, 16'b0110000000000000};
  //output values for bitwise Negation
  reg [15:0]arithmeticrightshiftResults[3:0] = {16'd0, 16'd4, 16'd2, 16'b1110000000000000};


  assign err = er;
  task error();
    begin
      er = 1'b1;
      #20;
      er = 1'b0;
      #20;
    end
  endtask
  task noShift();
    begin
      sim_shift_op = 2'b00;
      #20;
    end
  endtask

  task leftShift();
    begin
      sim_shift_op = 2'b01;
      #20;
    end
  endtask

  task rightShift();
    begin
      sim_shift_op = 2'b10;
      #20;
    end
  endtask

  task arithmeticRight_shift();
    begin
      sim_shift_op = 2'b11;
      #20;
    end
  endtask
  shifter DUT(.shift_in(sim_shift_in), .shift_op(sim_shift_op), .shift_out(sim_shift_out));
//  My testing procedure is as follows:
//    I will select 4  numbers and for each number check all 4 shift operations
  initial begin
  for(index = 0; index < numCases; index = index +1) begin
    sim_shift_in = shiftIn[index];
    noShift();

    numTest = numTest + 1;
    assert(sim_shift_out === noshiftResults[index])
    $display("No shift functioning as expected!");
    else begin
      error();
      testFailed = testFailed + 1;
      $error("ERROR: No shift not functioning as expected");
    end 


    leftShift();
    numTest = numTest + 1;
    assert(sim_shift_out === leftshiftResults[index])
    $display("Left shift functioning as expected!");
    else begin
      error();
      testFailed = testFailed + 1;
      $error("ERROR: Left shift not functioning as expected");
    end 
    
    rightShift();
    numTest = numTest + 1;
    assert(sim_shift_out === rightshiftResults[index])
    $display("Right shift functioning as expected!");
    else begin
      error();
      testFailed = testFailed + 1;
      $error("ERROR: Right shift not functioning as expected");
    end 
    
    arithmeticRight_shift();
    numTest = numTest + 1;
    assert(sim_shift_out === arithmeticrightshiftResults[index])
    $display("Arithmetic right shift functioning as expected!");
    else begin
      error();
      testFailed = testFailed + 1;
      $error("ERROR: Arithmetic right shift not functioning as expected");
    end 
    end
    $strobe("Failed %f tests out of %f", testFailed, numTest);
  end

  
  



endmodule: tb_shifter
