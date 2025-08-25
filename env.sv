class alu_env extends uvm_env;
  `uvm_component_utils(alu_env)
  
  alu_agent agnt;
  alu_scoreboard scb;
  alu_coverage cov;  // Coverage model 추가
  
  
  //--------------------------------------------------------
  //Constructor
  //--------------------------------------------------------
  function new(string name = "alu_env", uvm_component parent);
    super.new(name, parent);
  endfunction: new
  
  
  //--------------------------------------------------------
  //Build Phase
  //--------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    agnt = alu_agent::type_id::create("agnt", this);
    scb = alu_scoreboard::type_id::create("scb", this);
    cov = alu_coverage::type_id::create("cov", this);  // Factory 패턴 사용
    
  endfunction: build_phase
  
  //--------------------------------------------------------
  //Connect Phase - Enhanced with Coverage Connection
  //--------------------------------------------------------
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
    // Monitor → Scoreboard 연결
    agnt.mon.monitor_port.connect(scb.scoreboard_port);
    
    // Monitor → Coverage 연결
    agnt.mon.monitor_port.connect(cov.analysis_export);
    
  endfunction: connect_phase
  
  
  //--------------------------------------------------------
  //Run Phase
  //--------------------------------------------------------
  task run_phase (uvm_phase phase);
    super.run_phase(phase);
    
  endtask: run_phase
  
  
endclass: alu_env
