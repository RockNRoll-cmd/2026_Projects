// UVM Components Package
// Package file to compile all UVM base components

`ifndef UVM_COMPONENTS_PKG_SV
`define UVM_COMPONENTS_PKG_SV

package uvm_components_pkg;
  
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  
  // Include all component files
  `include "uvm_base_driver.sv"
  `include "uvm_base_monitor.sv"
  `include "uvm_base_agent.sv"
  `include "uvm_base_scoreboard.sv"
  `include "uvm_base_env.sv"
  
endpackage : uvm_components_pkg

`endif // UVM_COMPONENTS_PKG_SV
