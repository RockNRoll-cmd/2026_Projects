// UVM Base Agent
// Generic agent component for UVM testbenches

`ifndef UVM_BASE_AGENT_SV
`define UVM_BASE_AGENT_SV

class uvm_base_agent #(type REQ = uvm_sequence_item, type RSP = REQ) extends uvm_agent;
  
  `uvm_component_param_utils(uvm_base_agent #(REQ, RSP))
  
  // Agent components
  uvm_base_driver #(REQ, RSP) driver;
  uvm_base_monitor #(REQ) monitor;
  uvm_sequencer #(REQ, RSP) sequencer;
  
  // Configuration
  bit is_active = UVM_ACTIVE;
  
  // Constructor
  function new(string name = "uvm_base_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  // Build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    // Create monitor (always created for both active and passive agents)
    monitor = uvm_base_monitor#(REQ)::type_id::create("monitor", this);
    
    // Create driver and sequencer only for active agents
    if (is_active == UVM_ACTIVE) begin
      driver = uvm_base_driver#(REQ, RSP)::type_id::create("driver", this);
      sequencer = uvm_sequencer#(REQ, RSP)::type_id::create("sequencer", this);
    end
  endfunction
  
  // Connect phase
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
    // Connect driver to sequencer for active agents
    if (is_active == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction
  
  // Run phase
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    // Agent-specific runtime tasks can be added here
  endtask
  
endclass

`endif // UVM_BASE_AGENT_SV
