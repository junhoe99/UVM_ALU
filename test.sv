
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
  endfunction: new

  
  //--------------------------------------------------------
  //Build Phase
  //--------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    env = alu_env::type_id::create("env", this);

  endfunction: build_phase

  
  //--------------------------------------------------------
  //Connect Phase
  //--------------------------------------------------------
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

  endfunction: connect_phase

  
  //--------------------------------------------------------
  //Run Phase - Enhanced with more comprehensive testing
  //--------------------------------------------------------
  task run_phase (uvm_phase phase);
    super.run_phase(phase);
    $display("[TEST_CLASS] Starting ALU Verification Test!");

    phase.raise_objection(this);

    // Step 1: Reset sequence
    $display("[TEST_CLASS] Step 1: Applying Reset");
    reset_seq = alu_base_sequence::type_id::create("reset_seq");
    reset_seq.start(env.agnt.seqr);
    #20;

    // Step 2: Basic functional tests
    $display("[TEST_CLASS] Step 2: Basic Random Tests (100 iterations)");
    repeat(100) begin
      test_seq = alu_test_sequence::type_id::create("test_seq");
      test_seq.start(env.agnt.seqr);
      #10;
    end
    
    $display("[TEST_CLASS] ALU Verification Test Completed!");
    phase.drop_objection(this);

  endtask: run_phase


endclass: alu_test

//--------------------------------------------------------
// Enhanced Test with Directed Scenarios
//--------------------------------------------------------
class alu_directed_test extends uvm_test;

  alu_env env;
  alu_base_sequence reset_seq;
  alu_add_sub_directed_sequence add_sub_seq;
  alu_mul_div_directed_sequence mul_div_seq;
  alu_edge_case_sequence edge_seq;

  function new(string name = "alu_directed_test", uvm_component parent);
    super.new(name, parent);
  endfunction: new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = alu_env::type_id::create("env", this);
  endfunction: build_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction: connect_phase

  task run_phase (uvm_phase phase);
    super.run_phase(phase);
    $display("[DIRECTED_TEST] Starting Directed ALU Test!");

    phase.raise_objection(this);

    // Reset
    reset_seq = alu_base_sequence::type_id::create("reset_seq");
    reset_seq.start(env.agnt.seqr);
    #20;

    // Directed test scenarios
    $display("[DIRECTED_TEST] Running ADD/SUB directed tests");
    repeat(20) begin
      add_sub_seq = alu_add_sub_directed_sequence::type_id::create("add_sub_seq");
      add_sub_seq.start(env.agnt.seqr);
      #10;
    end

    $display("[DIRECTED_TEST] Running MUL/DIV directed tests");
    repeat(20) begin
      mul_div_seq = alu_mul_div_directed_sequence::type_id::create("mul_div_seq");
      mul_div_seq.start(env.agnt.seqr);
      #10;
    end

    $display("[DIRECTED_TEST] Running edge case tests");
    repeat(10) begin
      edge_seq = alu_edge_case_sequence::type_id::create("edge_seq");
      edge_seq.start(env.agnt.seqr);
      #10;
    end

    $display("[DIRECTED_TEST] Directed ALU Test Completed!");
    phase.drop_objection(this);

  endtask: run_phase

endclass: alu_directed_test
