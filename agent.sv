
class alu_agent extends uvm_agent;
  `uvm_component_utils(alu_agent)
  
  alu_driver handle_drv; 
  // driver.sv에서 alu_driver라는 이름의 설계도를 미리 그려서 보유 중.
  // agent.sv에서 alu_driver라는 설계도로 만든 물건을 담을 빈 그릇(handle)에 drv라는 이름표만 붙여둔 상태 
  alu_monitor mon; 
  alu_sequencer seqr;  
  
    
  //--------------------------------------------------------
  //Constructor
  //--------------------------------------------------------
  function new(string name = "alu_agent", uvm_component parent);
    super.new(name, parent);
    `uvm_info("AGENT_CLASS", "Inside Constructor!", UVM_HIGH)
  endfunction: new
  
  
  //--------------------------------------------------------
  //Build Phase
  //--------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("AGENT_CLASS", "Build Phase!", UVM_HIGH)
    
    handle_drv = alu_driver::type_id::create("drv", this);  
    // alu_driver라는 설계도를 factory( ::type_id::create() )에 갖고가서 실제 물건(object)를 생성하고, 
    // 앞서 이름표를 붙여두었던 빈 그릇(handle)인 drv에 담는다
    mon = alu_monitor::type_id::create("mon", this);
    seqr = alu_sequencer::type_id::create("seqr", this);
    
  endfunction: build_phase
  
  
  //--------------------------------------------------------
  //Connect Phase
  //--------------------------------------------------------
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("AGENT_CLASS", "Connect Phase!", UVM_HIGH)
    
    handle_drv.seq_item_port.connect(seqr.seq_item_export);
    
  endfunction: connect_phase
  
  
  //--------------------------------------------------------
  //Run Phase
  //--------------------------------------------------------
  task run_phase (uvm_phase phase);
    super.run_phase(phase);
    
  endtask: run_phase
  
  
endclass: alu_agent
