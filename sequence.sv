// Object class

//--------------------------------------------------------
// Base Reset Sequence
//--------------------------------------------------------
class alu_base_sequence extends uvm_sequence;
  `uvm_object_utils(alu_base_sequence)
  
  alu_sequence_item reset_pkt;
  
  function new(string name= "alu_base_sequence");
    super.new(name);
    `uvm_info("BASE_SEQ", "Inside Constructor!", UVM_HIGH)
  endfunction
  
  task body();
    `uvm_info("BASE_SEQ", "Inside body task!", UVM_HIGH)
    
    reset_pkt = alu_sequence_item::type_id::create("reset_pkt");
    start_item(reset_pkt);
    reset_pkt.randomize() with {reset==1;};
    finish_item(reset_pkt);
        
  endtask: body
  
endclass: alu_base_sequence

//--------------------------------------------------------
// Basic Arithmetic Test Sequence
//--------------------------------------------------------
class alu_test_sequence extends alu_base_sequence;
  `uvm_object_utils(alu_test_sequence)
  
  alu_sequence_item item;
  
  function new(string name= "alu_test_sequence");
    super.new(name);
    `uvm_info("TEST_SEQ", "Inside Constructor!", UVM_HIGH)
  endfunction
  
  task body();
    `uvm_info("TEST_SEQ", "Inside body task!", UVM_HIGH)
    
    item = alu_sequence_item::type_id::create("item");
    start_item(item);
    item.randomize() with {reset==0;};
    finish_item(item);
        
  endtask: body
  
endclass: alu_test_sequence

//--------------------------------------------------------
// Directed ADD/SUB Test for Carry/Overflow Detection
//--------------------------------------------------------
class alu_add_sub_directed_sequence extends uvm_sequence;
  `uvm_object_utils(alu_add_sub_directed_sequence)
  
  alu_sequence_item item;
  
  function new(string name= "alu_add_sub_directed_sequence");
    super.new(name);
    `uvm_info("ADD_SUB_SEQ", "Inside Constructor!", UVM_HIGH)
  endfunction
  
  task body();
    `uvm_info("ADD_SUB_SEQ", "Testing ADD/SUB with carry scenarios!", UVM_LOW)
    
    // Test Case 1: Large numbers to generate carry
    item = alu_sequence_item::type_id::create("item");
    start_item(item);
    item.randomize() with {
      reset == 0;
      op_code == 0; // ADD
      a >= 200;     // Large values likely to cause carry
      b >= 200;
    };
    finish_item(item);
    
    // Test Case 2: Subtraction with potential underflow
    item = alu_sequence_item::type_id::create("item");
    start_item(item);
    item.randomize() with {
      reset == 0;
      op_code == 1; // SUB
      a <= 50;      // Small - Large = negative (underflow)
      b >= 100;
    };
    finish_item(item);
        
  endtask: body
  
endclass: alu_add_sub_directed_sequence

//--------------------------------------------------------
// Directed MUL/DIV Test
//--------------------------------------------------------
class alu_mul_div_directed_sequence extends uvm_sequence;
  `uvm_object_utils(alu_mul_div_directed_sequence)
  
  alu_sequence_item item;
  
  function new(string name= "alu_mul_div_directed_sequence");
    super.new(name);
    `uvm_info("MUL_DIV_SEQ", "Inside Constructor!", UVM_HIGH)
  endfunction
  
  task body();
    `uvm_info("MUL_DIV_SEQ", "Testing MUL/DIV operations!", UVM_LOW)
    
    // Test Case 1: Multiplication with potential overflow
    item = alu_sequence_item::type_id::create("item");
    start_item(item);
    item.randomize() with {
      reset == 0;
      op_code == 2; // MUL
      a >= 16;      // 16 * 16 = 256 > 8-bit
      b >= 16;
    };
    finish_item(item);
    
    // Test Case 2: Division test
    item = alu_sequence_item::type_id::create("item");
    start_item(item);
    item.randomize() with {
      reset == 0;
      op_code == 3; // DIV
      a >= 50;
      b inside {[2:10]}; // Safe divisor
    };
    finish_item(item);
        
  endtask: body
  
endclass: alu_mul_div_directed_sequence

//--------------------------------------------------------
// Edge Case Test Sequence
//--------------------------------------------------------
class alu_edge_case_sequence extends uvm_sequence;
  `uvm_object_utils(alu_edge_case_sequence)
  
  alu_sequence_item item;
  
  function new(string name= "alu_edge_case_sequence");
    super.new(name);
    `uvm_info("EDGE_SEQ", "Inside Constructor!", UVM_HIGH)
  endfunction
  
  task body();
    `uvm_info("EDGE_SEQ", "Testing edge cases!", UVM_LOW)
    
    // Test Case 1: Zero operands
    item = alu_sequence_item::type_id::create("item");
    start_item(item);
    item.randomize() with {
      reset == 0;
      a == 0;
      op_code inside {0,1,2}; // All except DIV
    };
    finish_item(item);
    
    // Test Case 2: Maximum values
    item = alu_sequence_item::type_id::create("item");
    start_item(item);
    item.randomize() with {
      reset == 0;
      a == 255;
      b == 255;
      op_code inside {0,1,2,3};
    };
    finish_item(item);
    
    // Test Case 3: Identity operations
    item = alu_sequence_item::type_id::create("item");
    start_item(item);
    item.randomize() with {
      reset == 0;
      b == 1;
      op_code inside {2,3}; // MUL by 1, DIV by 1
    };
    finish_item(item);
        
  endtask: body
  
endclass: alu_edge_case_sequence
