// AXI4-Lite Verification Agent
// SystemVerilog agent for AXI4-Lite protocol verification

`ifndef AXI4_LITE_AGENT_SV
`define AXI4_LITE_AGENT_SV

// AXI4-Lite Transaction
class axi4_lite_transaction extends uvm_sequence_item;
  
  // Address Write Channel
  rand bit [31:0] awaddr;
  rand bit [2:0]  awprot;
  bit             awvalid;
  bit             awready;
  
  // Write Data Channel
  rand bit [31:0] wdata;
  rand bit [3:0]  wstrb;
  bit             wvalid;
  bit             wready;
  
  // Write Response Channel
  bit [1:0]       bresp;
  bit             bvalid;
  bit             bready;
  
  // Address Read Channel
  rand bit [31:0] araddr;
  rand bit [2:0]  arprot;
  bit             arvalid;
  bit             arready;
  
  // Read Data Channel
  bit [31:0]      rdata;
  bit [1:0]       rresp;
  bit             rvalid;
  bit             rready;
  
  // Transaction type
  rand bit is_write;
  
  `uvm_object_utils_begin(axi4_lite_transaction)
    `uvm_field_int(awaddr, UVM_ALL_ON)
    `uvm_field_int(wdata, UVM_ALL_ON)
    `uvm_field_int(araddr, UVM_ALL_ON)
    `uvm_field_int(rdata, UVM_ALL_ON)
    `uvm_field_int(is_write, UVM_ALL_ON)
  `uvm_object_utils_end
  
  function new(string name = "axi4_lite_transaction");
    super.new(name);
  endfunction
  
  // Constraints
  constraint addr_aligned_c {
    awaddr[1:0] == 2'b00;
    araddr[1:0] == 2'b00;
  }
  
  constraint valid_strobe_c {
    wstrb != 4'b0000;
  }
  
endclass

// AXI4-Lite Driver
class axi4_lite_driver extends uvm_driver #(axi4_lite_transaction);
  
  `uvm_component_utils(axi4_lite_driver)
  
  virtual axi4_lite_if vif;
  
  function new(string name = "axi4_lite_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual axi4_lite_if)::get(this, "", "vif", vif)) begin
      `uvm_fatal(get_type_name(), "Virtual interface not found")
    end
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(req);
      if (req.is_write) begin
        drive_write(req);
      end else begin
        drive_read(req);
      end
      seq_item_port.item_done();
    end
  endtask
  
  virtual task drive_write(axi4_lite_transaction trans);
    // Write Address Phase
    @(posedge vif.aclk);
    vif.awaddr <= trans.awaddr;
    vif.awprot <= trans.awprot;
    vif.awvalid <= 1'b1;
    
    // Wait for awready
    do @(posedge vif.aclk);
    while (!vif.awready);
    vif.awvalid <= 1'b0;
    
    // Write Data Phase
    vif.wdata <= trans.wdata;
    vif.wstrb <= trans.wstrb;
    vif.wvalid <= 1'b1;
    
    // Wait for wready
    do @(posedge vif.aclk);
    while (!vif.wready);
    vif.wvalid <= 1'b0;
    
    // Write Response Phase
    vif.bready <= 1'b1;
    do @(posedge vif.aclk);
    while (!vif.bvalid);
    trans.bresp = vif.bresp;
    vif.bready <= 1'b0;
  endtask
  
  virtual task drive_read(axi4_lite_transaction trans);
    // Read Address Phase
    @(posedge vif.aclk);
    vif.araddr <= trans.araddr;
    vif.arprot <= trans.arprot;
    vif.arvalid <= 1'b1;
    
    // Wait for arready
    do @(posedge vif.aclk);
    while (!vif.arready);
    vif.arvalid <= 1'b0;
    
    // Read Data Phase
    vif.rready <= 1'b1;
    do @(posedge vif.aclk);
    while (!vif.rvalid);
    trans.rdata = vif.rdata;
    trans.rresp = vif.rresp;
    vif.rready <= 1'b0;
  endtask
  
endclass

// AXI4-Lite Monitor
class axi4_lite_monitor extends uvm_monitor;
  
  `uvm_component_utils(axi4_lite_monitor)
  
  virtual axi4_lite_if vif;
  uvm_analysis_port #(axi4_lite_transaction) analysis_port;
  
  function new(string name = "axi4_lite_monitor", uvm_component parent = null);
    super.new(name, parent);
    analysis_port = new("analysis_port", this);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual axi4_lite_if)::get(this, "", "vif", vif)) begin
      `uvm_fatal(get_type_name(), "Virtual interface not found")
    end
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    axi4_lite_transaction trans;
    
    forever begin
      trans = axi4_lite_transaction::type_id::create("trans");
      
      // Monitor for write or read transaction
      fork
        monitor_write(trans);
        monitor_read(trans);
      join_any
      disable fork;
      
      analysis_port.write(trans);
    end
  endtask
  
  virtual task monitor_write(axi4_lite_transaction trans);
    // Wait for write address
    do @(posedge vif.aclk);
    while (!(vif.awvalid && vif.awready));
    
    trans.is_write = 1'b1;
    trans.awaddr = vif.awaddr;
    trans.awprot = vif.awprot;
    
    // Wait for write data
    do @(posedge vif.aclk);
    while (!(vif.wvalid && vif.wready));
    trans.wdata = vif.wdata;
    trans.wstrb = vif.wstrb;
    
    // Wait for write response
    do @(posedge vif.aclk);
    while (!(vif.bvalid && vif.bready));
    trans.bresp = vif.bresp;
  endtask
  
  virtual task monitor_read(axi4_lite_transaction trans);
    // Wait for read address
    do @(posedge vif.aclk);
    while (!(vif.arvalid && vif.arready));
    
    trans.is_write = 1'b0;
    trans.araddr = vif.araddr;
    trans.arprot = vif.arprot;
    
    // Wait for read data
    do @(posedge vif.aclk);
    while (!(vif.rvalid && vif.rready));
    trans.rdata = vif.rdata;
    trans.rresp = vif.rresp;
  endtask
  
endclass

`endif // AXI4_LITE_AGENT_SV
