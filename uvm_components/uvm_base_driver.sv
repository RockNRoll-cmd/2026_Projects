// UVM Base Driver
// Generic driver component for UVM testbenches

`ifndef UVM_BASE_DRIVER_SV
`define UVM_BASE_DRIVER_SV

class uvm_base_driver #(type REQ = uvm_sequence_item, type RSP = REQ) extends uvm_driver #(REQ, RSP);
  
  `uvm_component_param_utils(uvm_base_driver #(REQ, RSP))
  
  // Virtual interface handle
  virtual interface dut_if vif;
  
  // Constructor
  function new(string name = "uvm_base_driver", uvm_component parent = null);
    super.new(name, parent);
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
    forever begin
      seq_item_port.get_next_item(req);
      drive_item(req);
      seq_item_port.item_done();
    end
  endtask
  
  // Drive transaction - to be overridden by specific drivers
  virtual task drive_item(REQ req);
    `uvm_info(get_type_name(), $sformatf("Driving transaction: %s", req.convert2string()), UVM_HIGH)
    // Default implementation - wait for one clock cycle
    @(posedge vif.clk);
  endtask
  
  // Reset the driver
  virtual task reset();
    `uvm_info(get_type_name(), "Resetting driver", UVM_MEDIUM)
    // Default reset behavior - can be overridden
  endtask
  
endclass

`endif // UVM_BASE_DRIVER_SV
