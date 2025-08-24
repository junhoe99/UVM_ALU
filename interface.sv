

interface alu_interface(input logic clock);
  

  logic reset;
  
  logic[7:0] a, b;
  logic[3:0] op_code;
  logic[7:0] result;
  bit carry_out;
  
  //--------------------------------------------------------
  //Assertions for Protocol Checking
  //--------------------------------------------------------
  
  // Division by zero check
  property div_by_zero_check;
    @(posedge clock) (op_code == 3) |-> (b != 0);
  endproperty
  
  assert_div_by_zero: assert property(div_by_zero_check)
    else $error("Division by zero detected!");
  
  // Valid opcode check
  property valid_opcode_check;
    @(posedge clock) op_code inside {0,1,2,3,4,5};
  endproperty
  
  assert_valid_opcode: assert property(valid_opcode_check)
    else $error("Invalid opcode detected: %0d", op_code);
  
endinterface: alu_interface