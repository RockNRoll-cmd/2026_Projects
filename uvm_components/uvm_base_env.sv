// UVM Base Environment
// Top-level environment containing all verification components

`ifndef UVM_BASE_ENV_SV
`define UVM_BASE_ENV_SV

class uvm_base_env #(type REQ = uvm_sequence_item, type RSP = REQ) extends uvm_env;
  
  `uvm_component_param_utils(uvm_base_env #(REQ, RSP))
  
  // Environment components
  uvm_base_agent #(REQ, RSP) agent;
  uvm_base_scoreboard #(REQ) scoreboard;
  
  // Configuration
  bit has_scoreboard = 1;
  
  // Constructor
  function new(string name = "uvm_base_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  // Build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    // Create agent
    agent = uvm_base_agent#(REQ, RSP)::type_id::create("agent", this);
    
    // Create scoreboard if enabled
    if (has_scoreboard) begin
      scoreboard = uvm_base_scoreboard#(REQ)::type_id::create("scoreboard", this);
    end
  endfunction
  
  // Connect phase
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
    // Connect monitor to scoreboard
    if (has_scoreboard) begin
      agent.monitor.analysis_port.connect(scoreboard.analysis_export);
    end
  endfunction
  
  // End of elaboration phase
  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    `uvm_info(get_type_name(), "Environment topology:", UVM_LOW)
    this.print();
  endfunction
  
endclass

`endif // UVM_BASE_ENV_SV
