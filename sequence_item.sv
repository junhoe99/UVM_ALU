//Object class


class alu_sequence_item extends uvm_sequence_item;
  `uvm_object_utils(alu_sequence_item)

  //--------------------------------------------------------
  //Instantiation
  //--------------------------------------------------------
  rand logic reset;
  rand logic [7:0] a, b;
  rand logic [3:0] op_code;
  
  logic [7:0] result; //output
  bit carry_out; // output

  //--------------------------------------------------------
  //Coverage
  //--------------------------------------------------------
  covergroup alu_cg;
    op_code_cp: coverpoint op_code {
      bins add_op = {0};
      bins sub_op = {1};
      bins mul_op = {2};
      bins div_op = {3};
    }
    
    a_cp: coverpoint a {
      bins low_range = {[10:15]};
      bins high_range = {[16:20]};
    }
    
    b_cp: coverpoint b {
      bins low_range = {[1:5]};
      bins high_range = {[6:10]};
    }
    
    // Cross coverage
    op_a_cross: cross op_code_cp, a_cp;
    op_b_cross: cross op_code_cp, b_cp;
  endgroup

  //--------------------------------------------------------
  //Default Constraints
  //--------------------------------------------------------
  constraint input1_c {a inside {[10:20]};}
  constraint input2_c {b inside {[1:10]};}
  constraint op_code_c {op_code inside {0,1,2,3};}
  
  
  //--------------------------------------------------------
  //Constructor
  //--------------------------------------------------------
  function new(string name = "alu_sequence_item");
    super.new(name);
    alu_cg = new();
  endfunction: new

  //--------------------------------------------------------
  //Post Randomize - Sample Coverage
  //--------------------------------------------------------
  function void post_randomize();
    alu_cg.sample();
  endfunction

endclass: alu_sequence_item