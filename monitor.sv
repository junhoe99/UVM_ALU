
class alu_monitor extends uvm_monitor;
  `uvm_component_utils(alu_monitor)
  
  virtual alu_interface vif;
  alu_sequence_item item;
  
  uvm_analysis_port #(alu_sequence_item) monitor_port;
  
  
  //--------------------------------------------------------
  //Constructor
  //--------------------------------------------------------
  function new(string name = "alu_monitor", uvm_component parent);
    super.new(name, parent);
    `uvm_info("MONITOR_CLASS", "Inside Constructor!", UVM_HIGH)
  endfunction: new
  
  
  //--------------------------------------------------------
  //Build Phase
  //--------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("MONITOR_CLASS", "Build Phase!", UVM_HIGH)
    
    // port 설정
    monitor_port = new("monitor_port", this);
    
    if(!(uvm_config_db #(virtual alu_interface)::get(this, "*", "vif", vif))) begin
      `uvm_error("MONITOR_CLASS", "Failed to get VIF from config DB!")
    end
    
  endfunction: build_phase
  
  //--------------------------------------------------------
  //Connect Phase
  //--------------------------------------------------------
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("MONITOR_CLASS", "Connect Phase!", UVM_HIGH)
    
  endfunction: connect_phase
  
  
  //--------------------------------------------------------
  //Run Phase
  //--------------------------------------------------------
  task run_phase (uvm_phase phase);
    super.run_phase(phase);
    `uvm_info("MONITOR_CLASS", "Inside Run Phase!", UVM_HIGH)
    
    forever begin
      item = alu_sequence_item::type_id::create("item");
      
      wait(!vif.reset);
      
      //sample inputs
      @(posedge vif.clock);
      item.a = vif.a;
      item.b = vif.b;
      item.op_code = vif.op_code;
      
      //sample outputs
      @(posedge vif.clock);
      item.result = vif.result;
      item.carry_out = vif.carry_out;
      
      // Enhanced logging for debugging
      `uvm_info("MONITOR_CLASS", 
                $sformatf("Captured: A=%0h, B=%0h, OP=%0d, Result=%0h, Carry=%0b", 
                         item.a, item.b, item.op_code, item.result, item.carry_out), 
                UVM_MEDIUM)
      
      // send item to scoreboard
      monitor_port.write(item);
    end
        
  endtask: run_phase
  
  
endclass: alu_monitor
