

class alu_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(alu_scoreboard)
  
  uvm_analysis_imp #(alu_sequence_item, alu_scoreboard) scoreboard_port;
  
  alu_sequence_item transactions[$];
  
  // Statistics
  int passed_count = 0;
  int failed_count = 0;
  int total_count = 0;
  
  
  //--------------------------------------------------------
  //Constructor
  //--------------------------------------------------------
  function new(string name = "alu_scoreboard", uvm_component parent);
    super.new(name, parent);
    `uvm_info("SCB_CLASS", "Inside Constructor!", UVM_HIGH)
  endfunction: new
  
  
  //--------------------------------------------------------
  //Build Phase
  //--------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("SCB_CLASS", "Build Phase!", UVM_HIGH)
   
    scoreboard_port = new("scoreboard_port", this);
    
  endfunction: build_phase
  
  
  //--------------------------------------------------------
  //Connect Phase
  //--------------------------------------------------------
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("SCB_CLASS", "Connect Phase!", UVM_HIGH)
    
   
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
    `uvm_info("SCB_CLASS", "Run Phase!", UVM_HIGH)
   
    forever begin
      /*
      // get the packet
      // generate expected value
      // compare it with actual value
      // score the transactions accordingly
      */
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
    logic [7:0] expected;
    logic [7:0] actual;
    
    total_count++;
    
    case(curr_trans.op_code)
      0: begin //A + B
        expected = curr_trans.a + curr_trans.b;
      end
      1: begin //A - B
        expected = curr_trans.a - curr_trans.b;
      end
      2: begin //A * B
        expected = curr_trans.a * curr_trans.b;
      end
      3: begin //A / B
        expected = curr_trans.a / curr_trans.b;
      end
    endcase
    
    actual = curr_trans.result;
    
    if(actual != expected) begin
      failed_count++;
      `uvm_error("COMPARE", $sformatf("Transaction failed! ACT=%d, EXP=%d, A=%d, B=%d, OP=%d", 
                 actual, expected, curr_trans.a, curr_trans.b, curr_trans.op_code))
    end
    else begin
      passed_count++;
      `uvm_info("COMPARE", $sformatf("Transaction Passed! ACT=%d, EXP=%d, A=%d, B=%d, OP=%d", 
                actual, expected, curr_trans.a, curr_trans.b, curr_trans.op_code), UVM_LOW)
    end
    
    // 주기적으로 통계 출력
    if(total_count % 20 == 0) begin
      `uvm_info("STATS", $sformatf("Statistics: Total=%d, Passed=%d, Failed=%d, Pass Rate=%.1f%%", 
                total_count, passed_count, failed_count, 
                (real'(passed_count)/real'(total_count))*100.0), UVM_LOW)
    end
    
  endtask: compare
  
  
  //--------------------------------------------------------
  //Final Report Phase
  //--------------------------------------------------------
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    
    `uvm_info("SCB_FINAL_REPORT", "========================================", UVM_LOW)
    `uvm_info("SCB_FINAL_REPORT", "         SCOREBOARD FINAL REPORT", UVM_LOW)
    `uvm_info("SCB_FINAL_REPORT", "========================================", UVM_LOW)
    `uvm_info("SCB_FINAL_REPORT", $sformatf("Total Transactions: %0d", total_count), UVM_LOW)
    `uvm_info("SCB_FINAL_REPORT", $sformatf("Passed: %0d", passed_count), UVM_LOW)
    `uvm_info("SCB_FINAL_REPORT", $sformatf("Failed: %0d", failed_count), UVM_LOW)
    
    if(total_count > 0) begin
      real pass_rate = (real'(passed_count)/real'(total_count))*100.0;
      `uvm_info("SCB_FINAL_REPORT", $sformatf("Pass Rate: %.1f%%", pass_rate), UVM_LOW)
      
      if(pass_rate >= 95.0) begin
        `uvm_info("SCB_FINAL_REPORT", "*** TEST PASSED - Excellent! ***", UVM_LOW)
      end else if(pass_rate >= 80.0) begin
        `uvm_info("SCB_FINAL_REPORT", "*** TEST PASSED - Good ***", UVM_LOW)
      end else begin
        `uvm_error("SCB_FINAL_REPORT", "*** TEST FAILED - Low Pass Rate ***")
      end
    end else begin
      `uvm_error("SCB_FINAL_REPORT", "*** TEST FAILED - No Transactions ***")
    end
    
    `uvm_info("SCB_FINAL_REPORT", "========================================", UVM_LOW)
  endfunction: report_phase


endclass: alu_scoreboard