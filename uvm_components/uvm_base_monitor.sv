// UVM Base Monitor
// Generic monitor component for UVM testbenches

`ifndef UVM_BASE_MONITOR_SV
`define UVM_BASE_MONITOR_SV

class uvm_base_monitor #(type T = uvm_sequence_item) extends uvm_monitor;
  
  `uvm_component_param_utils(uvm_base_monitor #(T))
  
  // Analysis port for broadcasting transactions
  uvm_analysis_port #(T) analysis_port;
  
  // Virtual interface handle
  virtual interface dut_if vif;
  
  // Coverage
  covergroup transaction_cg;
    // Add coverpoints in derived classes
  endgroup
  
  // Constructor
  function new(string name = "uvm_base_monitor", uvm_component parent = null);
    super.new(name, parent);
    analysis_port = new("analysis_port", this);
  endfunction
  
  // Build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    // Get virtual interface from config DB
    if (!uvm_config_db#(virtual dut_if)::get(this, "", "vif", vif)) begin
      `uvm_fatal(get_type_name(), "Virtual interface not found in config DB")
    end
  endfunction
  
  // Run phase
  virtual task run_phase(uvm_phase phase);
    T trans;
    
    forever begin
      // Wait for transaction
      trans = T::type_id::create("trans");
      collect_transaction(trans);
      
      // Broadcast transaction
      `uvm_info(get_type_name(), $sformatf("Collected transaction: %s", trans.convert2string()), UVM_HIGH)
      analysis_port.write(trans);
      
      // Sample coverage
      if (transaction_cg != null) begin
        transaction_cg.sample();
      end
    end
  endtask
  
  // Collect transaction - to be overridden by specific monitors
  virtual task collect_transaction(T trans);
    // Default implementation - wait for one clock cycle
    @(posedge vif.clk);
  endtask
  
  // Check protocol - to be overridden for protocol checking
  virtual function void check_protocol();
    // Protocol checking logic
  endfunction
  
endclass

`endif // UVM_BASE_MONITOR_SV
