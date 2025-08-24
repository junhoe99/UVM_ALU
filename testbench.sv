// ALU Verification
// Date: 27 November 2022


`timescale 1ns/1ns

import uvm_pkg::*;
`include "uvm_macros.svh"


//--------------------------------------------------------
//Include Files
//--------------------------------------------------------
`include "test.sv"
`include "sequence_item.sv"
`include "sequence.sv"
`include "env.sv"
`include "agent.sv"
`include "sequencer.sv"
`include "monitor.sv"
`include "driver.sv"
`include "scoreboard.sv"
`include "interface.sv"





module top;
  
  //--------------------------------------------------------
  //Instantiation
  //--------------------------------------------------------

  logic clock;
  
  alu_interface intf(.clock(clock));
  
  alu dut(
    .clock(intf.clock),
    .reset(intf.reset),
    .A(intf.a),
    .B(intf.b),
    .ALU_Sel(intf.op_code),
    .ALU_Out(intf.result),
    .CarryOut(intf.carry_out)
  );
  
  
  //--------------------------------------------------------
  //Interface Setting
  //--------------------------------------------------------
  initial begin
    uvm_config_db #(virtual alu_interface)::set(null, "*", "vif", intf );
    //-- Refer: https://www.synopsys.com/content/dam/synopsys/services/whitepapers/hierarchical-testbench-configuration-using-uvm.pdf
  end
  
  
  
  //--------------------------------------------------------
  //Start The Test
  //--------------------------------------------------------
  initial begin
    run_test("alu_test");
  end
  
  
  //--------------------------------------------------------
  //Clock Generation
  //--------------------------------------------------------
  initial begin
    clock = 0;
    #5;
    forever begin
      clock = ~clock;
      #2;
    end
  end
  
  
  //--------------------------------------------------------
  //Maximum Simulation Time
  //--------------------------------------------------------
  initial begin
    #5000;
    $display("Sorry! Ran out of clock cycles!");
    $finish();
  end
  
  
  //--------------------------------------------------------
  //Generate Waveforms
  //--------------------------------------------------------
  initial begin
    $dumpfile("d.vcd");
    $dumpvars();
  end
  
  
  //--------------------------------------------------------
  //Coverage and Final Report
  //--------------------------------------------------------
  final begin
    $display("\n" + "="*60);
    $display("            SIMULATION SUMMARY REPORT");
    $display("="*60);
    $display("Simulation completed at time: %0t", $time);
    $display("Total clock cycles: %0d", ($time/4)); // 4ns period
    $display("="*60);
  end
  
  
  
endmodule: top