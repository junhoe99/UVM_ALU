//Object class


class alu_sequence_item extends uvm_sequence_item;
  `uvm_object_utils(alu_sequence_item)

  //--------------------------------------------------------
  //Input Variables (Stimulus)
  //--------------------------------------------------------
  rand logic reset;
  rand logic [7:0] a, b;
  rand logic [3:0] op_code;
  
  //--------------------------------------------------------
  //Response Variables
  //--------------------------------------------------------
  logic [7:0] result;
  bit carry_out;

  //--------------------------------------------------------
  //Enhanced Constraints for Better Coverage
  //--------------------------------------------------------
  
  // Basic input constraints
  constraint input1_c {a inside {[10:50]};}
  constraint input2_c {b inside {[1:20]};}
  
  // Operation code constraint (사칙연산만)
  constraint op_code_c {op_code inside {0,1,2,3};}
  
  // Special test scenarios constraints
  constraint divide_by_zero_avoid_c {
    (op_code == 3) -> (b != 0); // Avoid divide by zero in normal cases
  }
  
  // Edge cases for thorough testing
  constraint edge_case_c {
    a dist {0:=5, [1:9]:=10, [10:100]:=70, [200:255]:=15};
    b dist {0:=5, [1:9]:=10, [10:50]:=70, [100:255]:=15};
  }

  //--------------------------------------------------------
  //Constructor
  //--------------------------------------------------------
  function new(string name = "alu_sequence_item");
    super.new(name);
  endfunction: new
  
  //--------------------------------------------------------
  //Custom print method for better debugging
  //--------------------------------------------------------
  function void do_print(uvm_printer printer);
    super.do_print(printer);
    printer.print_field_int("a", a, 8, UVM_HEX);
    printer.print_field_int("b", b, 8, UVM_HEX);
    printer.print_field_int("op_code", op_code, 4, UVM_BIN);
    printer.print_field_int("result", result, 8, UVM_HEX);
    printer.print_field_int("carry_out", carry_out, 1, UVM_BIN);
  endfunction

endclass: alu_sequence_item
