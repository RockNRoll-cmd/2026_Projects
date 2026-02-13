// APB Verification Agent
// SystemVerilog agent for AMBA APB protocol verification

`ifndef APB_AGENT_SV
`define APB_AGENT_SV

// APB Transaction
class apb_transaction extends uvm_sequence_item;
  
  rand bit [31:0] paddr;
  rand bit [31:0] pwdata;
  bit [31:0]      prdata;
  rand bit        pwrite;
  bit             pslverr;
  rand bit [2:0]  pprot;
  
  `uvm_object_utils_begin(apb_transaction)
    `uvm_field_int(paddr, UVM_ALL_ON)
    `uvm_field_int(pwdata, UVM_ALL_ON)
    `uvm_field_int(prdata, UVM_ALL_ON)
    `uvm_field_int(pwrite, UVM_ALL_ON)
  `uvm_object_utils_end
  
  function new(string name = "apb_transaction");
    super.new(name);
  endfunction
  
  constraint addr_aligned_c {
    paddr[1:0] == 2'b00;
  }
  
endclass

// APB Driver
class apb_driver extends uvm_driver #(apb_transaction);
  
  `uvm_component_utils(apb_driver)
  
  virtual apb_if vif;
  
  function new(string name = "apb_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual apb_if)::get(this, "", "vif", vif)) begin
      `uvm_fatal(get_type_name(), "Virtual interface not found")
    end
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(req);
      drive_transfer(req);
      seq_item_port.item_done();
    end
  endtask
  
  virtual task drive_transfer(apb_transaction trans);
    // IDLE state
    @(posedge vif.pclk);
    vif.psel <= 1'b0;
    vif.penable <= 1'b0;
    
    // SETUP state
    @(posedge vif.pclk);
    vif.psel <= 1'b1;
    vif.paddr <= trans.paddr;
    vif.pwrite <= trans.pwrite;
    vif.pprot <= trans.pprot;
    if (trans.pwrite) begin
      vif.pwdata <= trans.pwdata;
    end
    vif.penable <= 1'b0;
    
    // ACCESS state
    @(posedge vif.pclk);
    vif.penable <= 1'b1;
    
    // Wait for pready
    while (!vif.pready) begin
      @(posedge vif.pclk);
    end
    
    // Capture read data if read operation
    if (!trans.pwrite) begin
      trans.prdata = vif.prdata;
    end
    trans.pslverr = vif.pslverr;
    
    // Return to IDLE
    @(posedge vif.pclk);
    vif.psel <= 1'b0;
    vif.penable <= 1'b0;
  endtask
  
endclass

// APB Monitor
class apb_monitor extends uvm_monitor;
  
  `uvm_component_utils(apb_monitor)
  
  virtual apb_if vif;
  uvm_analysis_port #(apb_transaction) analysis_port;
  
  function new(string name = "apb_monitor", uvm_component parent = null);
    super.new(name, parent);
    analysis_port = new("analysis_port", this);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual apb_if)::get(this, "", "vif", vif)) begin
      `uvm_fatal(get_type_name(), "Virtual interface not found")
    end
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    apb_transaction trans;
    
    forever begin
      trans = apb_transaction::type_id::create("trans");
      collect_transfer(trans);
      analysis_port.write(trans);
    end
  endtask
  
  virtual task collect_transfer(apb_transaction trans);
    // Wait for SETUP phase (psel=1, penable=0)
    do @(posedge vif.pclk);
    while (!(vif.psel && !vif.penable));
    
    trans.paddr = vif.paddr;
    trans.pwrite = vif.pwrite;
    trans.pprot = vif.pprot;
    if (vif.pwrite) begin
      trans.pwdata = vif.pwdata;
    end
    
    // Wait for ACCESS phase (psel=1, penable=1, pready=1)
    do @(posedge vif.pclk);
    while (!(vif.psel && vif.penable && vif.pready));
    
    if (!vif.pwrite) begin
      trans.prdata = vif.prdata;
    end
    trans.pslverr = vif.pslverr;
  endtask
  
endclass

// APB Sequencer
typedef uvm_sequencer #(apb_transaction) apb_sequencer;

// APB Agent
class apb_agent extends uvm_agent;
  
  `uvm_component_utils(apb_agent)
  
  apb_driver driver;
  apb_monitor monitor;
  apb_sequencer sequencer;
  
  function new(string name = "apb_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    monitor = apb_monitor::type_id::create("monitor", this);
    
    if (is_active == UVM_ACTIVE) begin
      driver = apb_driver::type_id::create("driver", this);
      sequencer = apb_sequencer::type_id::create("sequencer", this);
    end
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (is_active == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction
  
endclass

`endif // APB_AGENT_SV
