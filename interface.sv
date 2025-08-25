interface alu_interface(input logic clock);
  
  // Control signals
  logic reset;
  
  // Input signals
  logic[7:0] a, b;
  logic[3:0] op_code;  // 0-3: ADD, SUB, MUL, DIV만 지원
  
  // Output signals
  logic[7:0] result;
  bit carry_out;
  
  //--------------------------------------------------------
  // ALU SystemVerilog Assertions (SVA)
  // PPT 구성안 6️⃣번: Assertions & Protocol Checks
  //--------------------------------------------------------
  
  // 1. Reset Behavior Assertion
  property reset_behavior;
    @(posedge clock) reset |-> (result == 8'h00) && (carry_out == 1'b0);
  endproperty
  
  assert_reset: assert property (reset_behavior)
    else $error("ASSERTION FAIL: Reset behavior violated");
  
  // 2. Addition Overflow Detection
  property add_overflow_check;
    logic [8:0] expected_sum;
    @(posedge clock) disable iff (reset)
    (op_code == 4'b0000, expected_sum = a + b) |-> 
    (expected_sum > 255) ? (carry_out == 1'b1) : (carry_out == 1'b0);
  endproperty
  
  assert_add_overflow: assert property (add_overflow_check)
    else $error("ASSERTION FAIL: Addition carry flag incorrect");
  
  // 3. Addition Result Correctness
  property add_result_check;
    @(posedge clock) disable iff (reset)
    (op_code == 4'b0000) |-> (result == (a + b));
  endproperty
  
  assert_add_result: assert property (add_result_check)
    else $error("ASSERTION FAIL: Addition result incorrect");
  
  // 4. Subtraction Result Correctness
  property sub_result_check;
    @(posedge clock) disable iff (reset)
    (op_code == 4'b0001) |-> (result == (a - b));
  endproperty
  
  assert_sub_result: assert property (sub_result_check)
    else $error("ASSERTION FAIL: Subtraction result incorrect");
  
  // 5. Multiplication Result Correctness (8-bit truncated)
  property mul_result_check;
    logic [15:0] full_product;
    @(posedge clock) disable iff (reset)
    (op_code == 4'b0010, full_product = a * b) |-> 
    (result == full_product[7:0]);
  endproperty
  
  assert_mul_result: assert property (mul_result_check)
    else $error("ASSERTION FAIL: Multiplication result incorrect");
  
  // 6. Division by Zero Protection
  property div_by_zero_check;
    @(posedge clock) disable iff (reset)
    (op_code == 4'b0011) && (b == 8'h00) |-> (result == 8'hAC);
  endproperty
  
  assert_div_by_zero: assert property (div_by_zero_check)
    else $error("ASSERTION FAIL: Division by zero not handled properly");
  
  // 7. Valid Division Result
  property div_result_check;
    @(posedge clock) disable iff (reset)
    (op_code == 4'b0011) && (b != 8'h00) |-> (result == (a / b));
  endproperty
  
  assert_div_result: assert property (div_result_check)
    else $error("ASSERTION FAIL: Division result incorrect");
  
  // 8. Valid Operation Code Range (사칙연산만)
  property valid_opcode_range;
    @(posedge clock) disable iff (reset)
    op_code inside {4'b0000, 4'b0001, 4'b0010, 4'b0011}; // 0-3만 유효
  endproperty
  
  assert_valid_opcode: assert property (valid_opcode_range)
    else $warning("WARNING: Invalid operation code detected");
  
  // 9. Unknown Operation Default Value
  property unknown_op_default;
    @(posedge clock) disable iff (reset)
    !(op_code inside {4'b0000, 4'b0001, 4'b0010, 4'b0011}) |-> 
    (result == 8'hAC);
  endproperty
  
  assert_unknown_op: assert property (unknown_op_default)
    else $error("ASSERTION FAIL: Unknown operation should return 0xAC");
  
  //--------------------------------------------------------
  // Coverage Properties for Functional Verification
  //--------------------------------------------------------
  
  // Maximum Value Operations Coverage
  property max_value_coverage;
    @(posedge clock) disable iff (reset)
    $rose((a == 8'hFF) || (b == 8'hFF));
  endproperty
  
  cover_max_values: cover property (max_value_coverage);
  
  // Zero Result Coverage
  property zero_result_coverage;
    @(posedge clock) disable iff (reset)
    $rose(result == 8'h00);
  endproperty
  
  cover_zero_result: cover property (zero_result_coverage);
  
  // Carry Flag Coverage
  property carry_flag_coverage;
    @(posedge clock) disable iff (reset)
    $rose(carry_out == 1'b1);
  endproperty
  
  cover_carry_flag: cover property (carry_flag_coverage);
  
endinterface: alu_interface
