// UART Verification Agent
// SystemVerilog agent for UART protocol verification

`ifndef UART_AGENT_SV
`define UART_AGENT_SV

// UART Transaction
class uart_transaction extends uvm_sequence_item;
  
  rand bit [7:0] data;
  rand bit       parity;
  bit            parity_error;
  bit            frame_error;
  
  // Configuration
  int baud_rate = 115200;
  int data_bits = 8;
  int stop_bits = 1;
  bit parity_enable = 0;
  bit parity_odd = 0;  // 0=even, 1=odd
  
  `uvm_object_utils_begin(uart_transaction)
    `uvm_field_int(data, UVM_ALL_ON)
    `uvm_field_int(parity, UVM_ALL_ON)
    `uvm_field_int(parity_error, UVM_ALL_ON)
    `uvm_field_int(frame_error, UVM_ALL_ON)
  `uvm_object_utils_end
  
  function new(string name = "uart_transaction");
    super.new(name);
  endfunction
  
  function bit calculate_parity();
    bit calc_parity;
    calc_parity = ^data;  // XOR reduction
    if (parity_odd) begin
      calc_parity = !calc_parity;
    end
    return calc_parity;
  endfunction
  
endclass

// UART Driver
class uart_driver extends uvm_driver #(uart_transaction);
  
  `uvm_component_utils(uart_driver)
  
  virtual uart_if vif;
  int cached_baud_rate;
  int cached_bit_time;
  
  function new(string name = "uart_driver", uvm_component parent = null);
    super.new(name, parent);
    cached_baud_rate = 0;
    cached_bit_time = 0;
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual uart_if)::get(this, "", "vif", vif)) begin
      `uvm_fatal(get_type_name(), "Virtual interface not found")
    end
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(req);
      transmit_byte(req);
      seq_item_port.item_done();
    end
  endtask
  
  virtual task transmit_byte(uart_transaction trans);
    int bit_time;
    
    // Cache bit time calculation
    if (cached_baud_rate != trans.baud_rate) begin
      cached_baud_rate = trans.baud_rate;
      cached_bit_time = 1000000000 / trans.baud_rate;  // in ns
    end
    bit_time = cached_bit_time;
    
    // Start bit
    vif.tx <= 1'b0;
    #bit_time;
    
    // Data bits
    for (int i = 0; i < trans.data_bits; i++) begin
      vif.tx <= trans.data[i];
      #bit_time;
    end
    
    // Parity bit
    if (trans.parity_enable) begin
      vif.tx <= trans.calculate_parity();
      #bit_time;
    end
    
    // Stop bits
    for (int i = 0; i < trans.stop_bits; i++) begin
      vif.tx <= 1'b1;
      #bit_time;
    end
  endtask
  
endclass

// UART Monitor
class uart_monitor extends uvm_monitor;
  
  `uvm_component_utils(uart_monitor)
  
  virtual uart_if vif;
  uvm_analysis_port #(uart_transaction) analysis_port;
  
  // Configuration
  int baud_rate = 115200;
  int data_bits = 8;
  int stop_bits = 1;
  bit parity_enable = 0;
  bit parity_odd = 0;
  
  // Cached bit time
  int cached_baud_rate;
  int cached_bit_time;
  
  function new(string name = "uart_monitor", uvm_component parent = null);
    super.new(name, parent);
    analysis_port = new("analysis_port", this);
    cached_baud_rate = 0;
    cached_bit_time = 0;
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual uart_if)::get(this, "", "vif", vif)) begin
      `uvm_fatal(get_type_name(), "Virtual interface not found")
    end
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    uart_transaction trans;
    
    forever begin
      trans = uart_transaction::type_id::create("trans");
      trans.baud_rate = baud_rate;
      trans.data_bits = data_bits;
      trans.stop_bits = stop_bits;
      trans.parity_enable = parity_enable;
      trans.parity_odd = parity_odd;
      
      receive_byte(trans);
      analysis_port.write(trans);
    end
  endtask
  
  virtual task receive_byte(uart_transaction trans);
    int bit_time;
    bit sample_bit;
    
    // Cache bit time calculation
    if (cached_baud_rate != trans.baud_rate) begin
      cached_baud_rate = trans.baud_rate;
      cached_bit_time = 1000000000 / trans.baud_rate;  // in ns
    end
    bit_time = cached_bit_time;
    
    // Wait for start bit (falling edge)
    @(negedge vif.rx);
    
    // Sample in middle of start bit
    #(bit_time/2);
    if (vif.rx !== 1'b0) begin
      trans.frame_error = 1'b1;
      return;
    end
    
    // Data bits
    #(bit_time);
    for (int i = 0; i < trans.data_bits; i++) begin
      trans.data[i] = vif.rx;
      #bit_time;
    end
    
    // Parity bit
    if (trans.parity_enable) begin
      sample_bit = vif.rx;
      if (sample_bit !== trans.calculate_parity()) begin
        trans.parity_error = 1'b1;
      end
      #bit_time;
    end
    
    // Stop bits
    for (int i = 0; i < trans.stop_bits; i++) begin
      if (vif.rx !== 1'b1) begin
        trans.frame_error = 1'b1;
      end
      #bit_time;
    end
  endtask
  
endclass

// UART Sequencer
typedef uvm_sequencer #(uart_transaction) uart_sequencer;

// UART Agent
class uart_agent extends uvm_agent;
  
  `uvm_component_utils(uart_agent)
  
  uart_driver driver;
  uart_monitor monitor;
  uart_sequencer sequencer;
  
  function new(string name = "uart_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    monitor = uart_monitor::type_id::create("monitor", this);
    
    if (is_active == UVM_ACTIVE) begin
      driver = uart_driver::type_id::create("driver", this);
      sequencer = uart_sequencer::type_id::create("sequencer", this);
    end
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (is_active == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction
  
endclass

`endif // UART_AGENT_SV
