//--------------------------------------------------------
// ALU Functional Coverage Model
// PPT 구성안 4️⃣, 7️⃣번
//--------------------------------------------------------

class alu_coverage extends uvm_subscriber #(alu_sequence_item);
  `uvm_component_utils(alu_coverage)
  
  alu_sequence_item trans;
  
  //--------------------------------------------------------
  // Coverage Groups for Comprehensive ALU Verification
  //--------------------------------------------------------
  
  // 1. Basic Operation Coverage
  covergroup alu_operations_cg;
    option.per_instance = 1;
    option.name = "alu_operations";
    
    // Operation codes coverage (사칙연산만)
    cp_opcode: coverpoint trans.op_code {
      bins add_op = {0};    // Addition
      bins sub_op = {1};    // Subtraction
      bins mul_op = {2};    // Multiplication
      bins div_op = {3};    // Division
      illegal_bins invalid_ops = {[4:15]}; // Invalid operations
    }
    
    // Input ranges coverage for operand A
    cp_operand_a: coverpoint trans.a {
      bins zero     = {0};
      bins low      = {[1:15]};
      bins mid      = {[16:127]};
      bins high     = {[128:254]};
      bins max_val  = {255};
    }
    
    // Input ranges coverage for operand B
    cp_operand_b: coverpoint trans.b {
      bins zero     = {0};
      bins low      = {[1:15]};
      bins mid      = {[16:127]};
      bins high     = {[128:254]};
      bins max_val  = {255};
    }
  endgroup
  
  // 2. Result and Flag Coverage
  covergroup alu_results_cg;
    option.per_instance = 1;
    option.name = "alu_results";
    
    // Result ranges
    cp_result: coverpoint trans.result {
      bins zero_result = {0};
      bins low_result = {[1:63]};
      bins mid_result = {[64:191]};
      bins high_result = {[192:255]};
    }
    
    // Carry flag coverage
    cp_carry: coverpoint trans.carry_out {
      bins no_carry = {0};
      bins carry_set = {1};
    }
  endgroup
  
  // 3. Cross Coverage for Comprehensive Analysis
  covergroup alu_cross_cg;
    option.per_instance = 1;
    option.name = "alu_cross_coverage";
    
    cp_op: coverpoint trans.op_code {
      bins arithmetic = {0,1,2,3}; // 사칙연산만
    }
    
    cp_carry_cross: coverpoint trans.carry_out {
      bins carry_clear = {0};
      bins carry_set = {1};
    }
    
    // Cross coverage: Operation × Carry flag
    cross_op_carry: cross cp_op, cp_carry_cross {
      bins add_with_carry = binsof(cp_op.arithmetic) && binsof(cp_carry_cross.carry_set);
      bins add_no_carry = binsof(cp_op.arithmetic) && binsof(cp_carry_cross.carry_clear);
    }
  endgroup
  
  // 4. Edge Cases Coverage
  covergroup alu_edge_cases_cg;
    option.per_instance = 1;
    option.name = "alu_edge_cases";
    
    cp_edge_operands: coverpoint {trans.a, trans.b, trans.op_code} {
      // Maximum value operations
      bins max_add = {255, 255, 0};
      bins max_sub = {255, 255, 1};
      bins max_mul = {255, 255, 2};
      
      // Zero operand cases
      bins zero_a_add = {0, [1:255], 0};
      bins zero_b_add = {[1:255], 0, 0};
      bins zero_a_sub = {0, [1:255], 1};
      bins zero_b_sub = {[1:255], 0, 1};
      bins zero_a_mul = {0, [1:255], 2};
      bins zero_b_mul = {[1:255], 0, 2};
      
      // Division special cases
      bins div_by_one = {[1:255], 1, 3};
      bins div_equal = {[1:255], [1:255], 3} iff (trans.a == trans.b);
      
      // Identity operations
      bins mul_by_one = {[1:255], 1, 2};
      bins add_zero = {[1:255], 0, 0};
      bins sub_zero = {[1:255], 0, 1};
    }
  endgroup
  
  //--------------------------------------------------------
  //Constructor
  //--------------------------------------------------------
  function new(string name = "alu_coverage", uvm_component parent);
    super.new(name, parent);
    
    // Instantiate coverage groups
    alu_operations_cg = new();
    alu_results_cg = new();
    alu_cross_cg = new();
    alu_edge_cases_cg = new();
    
  endfunction: new
  
  //--------------------------------------------------------
  //Write method - called when transaction is received
  //--------------------------------------------------------
  function void write(alu_sequence_item t);
    trans = t;
    
    // Sample all coverage groups
    alu_operations_cg.sample();
    alu_results_cg.sample();
    alu_cross_cg.sample();
    alu_edge_cases_cg.sample();
    
  endfunction: write
  
  //--------------------------------------------------------
  //Report Phase - Coverage Summary
  //--------------------------------------------------------
  function void report_phase(uvm_phase phase);
    real op_coverage, result_coverage, cross_coverage, edge_coverage, total_coverage;
    
    super.report_phase(phase);
    
    op_coverage = alu_operations_cg.get_coverage();
    result_coverage = alu_results_cg.get_coverage();
    cross_coverage = alu_cross_cg.get_coverage();
    edge_coverage = alu_edge_cases_cg.get_coverage();
    total_coverage = (op_coverage + result_coverage + cross_coverage + edge_coverage) / 4.0;
    
    $display("=================================================");
    $display("ALU FUNCTIONAL COVERAGE SUMMARY");
    $display("=================================================");
    $display("Operations Coverage: %.2f%%", op_coverage);
    $display("Results Coverage: %.2f%%", result_coverage);
    $display("Cross Coverage: %.2f%%", cross_coverage);
    $display("Edge Cases Coverage: %.2f%%", edge_coverage);
    $display("=================================================");
    $display("TOTAL FUNCTIONAL COVERAGE: %.2f%%", total_coverage);
    $display("=================================================");
    
    // Coverage goal check (PPT에서 목표: ≥95%)
    if (total_coverage >= 95.0) begin
      $display("COVERAGE GOAL ACHIEVED! (>=95%%)");
    end else if (total_coverage >= 90.0) begin
      $display("NEAR COVERAGE GOAL (>=90%%)");
    end else begin
      $display("COVERAGE GOAL NOT MET (<90%%)");
    end
    
  endfunction: report_phase
  
endclass: alu_coverage
