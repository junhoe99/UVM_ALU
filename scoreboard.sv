

class alu_scoreboard extends uvm_scoreboard;
   `uvm_component_utils(alu_scoreboard)
  
  uvm_analysis_imp #(alu_sequence_item, alu_scoreboard) scoreboard_port;
  
  alu_sequence_item transactions[$];
  
  // Add statistics tracking variables at class level
  int total_transactions = 0;
  int passed_transactions = 0;
  
  //--------------------------------------------------------
  //Constructor
  //--------------------------------------------------------
  function new(string name = "alu_scoreboard", uvm_component parent);
    super.new(name, parent);
  endfunction: new
  
  
  //--------------------------------------------------------
  //Build Phase
  //--------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
   
    scoreboard_port = new("scoreboard_port", this);
    
  endfunction: build_phase
  
  
  //--------------------------------------------------------
  //Connect Phase
  //--------------------------------------------------------
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
   
  endfunction: connect_phase
  
  
  //--------------------------------------------------------
  //Write Method
  //--------------------------------------------------------
  function void write(alu_sequence_item item);
    transactions.push_back(item);
  endfunction: write 
  
  
  
  //--------------------------------------------------------
  //Run Phase
  //--------------------------------------------------------
  task run_phase (uvm_phase phase);
    super.run_phase(phase);
   
    forever begin
      alu_sequence_item curr_trans;
      wait((transactions.size() != 0));
      curr_trans = transactions.pop_front();
      compare(curr_trans);
      
    end
    
  endtask: run_phase
  
  //--------------------------------------------------------
  //Compare : Generate Expected Result and Compare with Actual
  //--------------------------------------------------------
  task compare(alu_sequence_item curr_trans);
    logic [7:0] expected_result;
    logic expected_carry;
    logic [8:0] temp_result; // 9-bit for overflow detection
    
    // Calculate expected results based on operation
    case(curr_trans.op_code)
      0: begin //A + B
        temp_result = {1'b0, curr_trans.a} + {1'b0, curr_trans.b};
        expected_result = temp_result[7:0];
        expected_carry = temp_result[8];
      end
      1: begin //A - B
        expected_result = curr_trans.a - curr_trans.b;
        expected_carry = 1'b0;
      end
      2: begin //A * B
        temp_result = curr_trans.a * curr_trans.b;
        expected_result = temp_result[7:0];
        expected_carry = (temp_result > 255) ? 1'b1 : 1'b0;
      end
      3: begin //A / B
        if (curr_trans.b != 0) begin
          expected_result = curr_trans.a / curr_trans.b;
          expected_carry = 1'b0;
        end else begin
          expected_result = 8'hAC; // Match design's divide-by-zero behavior
          expected_carry = 1'b0;
        end
      end
      default: begin
        expected_result = 8'hAC; // Default case from design
        expected_carry = 1'b0;
      end
    endcase
    
    // Compare results and provide detailed feedback
    if((curr_trans.result == expected_result) && (curr_trans.carry_out == expected_carry)) begin
      $display("[COMPARE] PASS: A=%0h, B=%0h, OP=%0s, Result=%0h(exp=%0h), Carry=%0b(exp=%0b)", 
               curr_trans.a, curr_trans.b, get_op_name(curr_trans.op_code),
               curr_trans.result, expected_result, 
               curr_trans.carry_out, expected_carry);
      passed_transactions++;
    end else begin
      $display("[COMPARE] FAIL: A=%0h, B=%0h, OP=%0s", curr_trans.a, curr_trans.b, get_op_name(curr_trans.op_code));
      
      if (curr_trans.result != expected_result)
        $display("  Result mismatch: ACT=%0h, EXP=%0h", curr_trans.result, expected_result);
      if (curr_trans.carry_out != expected_carry) 
        $display("  Carry mismatch: ACT=%0b, EXP=%0b", curr_trans.carry_out, expected_carry);
    end
    
    // Statistics tracking
    total_transactions++;
    
  endtask: compare
  
  //--------------------------------------------------------
  //Helper function to get operation name for better logging
  //--------------------------------------------------------
  function string get_op_name(logic [3:0] op_code);
    case(op_code)
      0: return "ADD";
      1: return "SUB"; 
      2: return "MUL";
      3: return "DIV";
      default: return "UNKNOWN";
    endcase
  endfunction
  
  //--------------------------------------------------------
  //Final Phase - Print Statistics
  //--------------------------------------------------------
  function void final_phase(uvm_phase phase);
    super.final_phase(phase);
    
    $display("[SCOREBOARD_STATS] Final Results: %0d/%0d transactions passed (%.1f%%)", 
             passed_transactions, total_transactions, 
             (total_transactions > 0) ? (passed_transactions * 100.0 / total_transactions) : 0.0);
  endfunction
  
endclass: alu_scoreboard
