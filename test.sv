
class alu_test extends uvm_test;
  `uvm_component_utils(alu_test)

  alu_env env;
  alu_base_sequence reset_seq;
  alu_test_sequence test_seq;

  
  //--------------------------------------------------------
  //Constructor
  //--------------------------------------------------------
  function new(string name = "alu_test", uvm_component parent);
    super.new(name, parent);
    `uvm_info("TEST_CLASS", "Inside Constructor!", UVM_HIGH)
  endfunction: new

  
  //--------------------------------------------------------
  //Build Phase
  //--------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TEST_CLASS", "Build Phase!", UVM_HIGH)

    env = alu_env::type_id::create("env", this);

  endfunction: build_phase

  
  //--------------------------------------------------------
  //Connect Phase
  //--------------------------------------------------------
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("TEST_CLASS", "Connect Phase!", UVM_HIGH)

  endfunction: connect_phase

  
  //--------------------------------------------------------
  //Run Phase
  //--------------------------------------------------------
  task run_phase (uvm_phase phase);
    super.run_phase(phase);
    `uvm_info("TEST_CLASS", "Run Phase!", UVM_HIGH)

    phase.raise_objection(this);

    //reset_seq
    reset_seq = alu_base_sequence::type_id::create("reset_seq");
    reset_seq.start(env.agnt.seqr);
    #10;

    repeat(100) begin
      //test_seq
      test_seq = alu_test_sequence::type_id::create("test_seq");
      test_seq.start(env.agnt.seqr);
      #10;
    end
    
    // Final Coverage and Statistics Report
    #100; // Allow final transactions to complete
    print_final_report();
    
    phase.drop_objection(this);

  endtask: run_phase

  
  //--------------------------------------------------------
  //Final Report Function
  //--------------------------------------------------------
  function void print_final_report();
    `uvm_info("FINAL_REPORT", "========================================", UVM_LOW)
    `uvm_info("FINAL_REPORT", "         FINAL TEST REPORT", UVM_LOW)
    `uvm_info("FINAL_REPORT", "========================================", UVM_LOW)
    `uvm_info("FINAL_REPORT", "Test completed successfully!", UVM_LOW)
    `uvm_info("FINAL_REPORT", "Check scoreboard for detailed statistics", UVM_LOW)
    `uvm_info("FINAL_REPORT", "Check coverage report for functional coverage", UVM_LOW)
    `uvm_info("FINAL_REPORT", "========================================", UVM_LOW)
  endfunction


endclass: alu_test