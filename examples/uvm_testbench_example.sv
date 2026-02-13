// Example: UVM Testbench Integration
// Demonstrates how to use the UVM base components

`ifndef UVM_TESTBENCH_EXAMPLE_SV
`define UVM_TESTBENCH_EXAMPLE_SV

// Include UVM base components
`include "../uvm_components/uvm_components_pkg.sv"

// Simple DUT interface
interface dut_if;
  logic clk;
  logic reset_n;
  logic [31:0] data_in;
  logic [31:0] data_out;
  logic valid;
  logic ready;
endinterface

// Custom transaction
class my_transaction extends uvm_sequence_item;
  rand bit [31:0] data;
  rand bit valid;
  
  `uvm_object_utils_begin(my_transaction)
    `uvm_field_int(data, UVM_ALL_ON)
    `uvm_field_int(valid, UVM_ALL_ON)
  `uvm_object_utils_end
  
  function new(string name = "my_transaction");
    super.new(name);
  endfunction
  
  constraint valid_data_c {
    valid dist {0 := 20, 1 := 80};
  }
endclass

// Custom sequence
class my_sequence extends uvm_sequence #(my_transaction);
  `uvm_object_utils(my_sequence)
  
  function new(string name = "my_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
    my_transaction trans;
    
    `uvm_info(get_type_name(), "Starting sequence", UVM_MEDIUM)
    
    repeat (10) begin
      trans = my_transaction::type_id::create("trans");
      start_item(trans);
      assert(trans.randomize());
      finish_item(trans);
    end
    
    `uvm_info(get_type_name(), "Sequence complete", UVM_MEDIUM)
  endtask
endclass

// Custom driver extending base driver
class my_driver extends uvm_base_driver #(my_transaction);
  `uvm_component_utils(my_driver)
  
  function new(string name = "my_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  virtual task drive_item(my_transaction req);
    @(posedge vif.clk);
    vif.data_in <= req.data;
    vif.valid <= req.valid;
    `uvm_info(get_type_name(), 
      $sformatf("Driving: data=0x%0h, valid=%0b", req.data, req.valid), 
      UVM_HIGH)
  endtask
endclass

// Custom monitor extending base monitor
class my_monitor extends uvm_base_monitor #(my_transaction);
  `uvm_component_utils(my_monitor)
  
  function new(string name = "my_monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  virtual task collect_transaction(my_transaction trans);
    @(posedge vif.clk);
    if (vif.valid && vif.ready) begin
      trans.data = vif.data_out;
      trans.valid = vif.valid;
      `uvm_info(get_type_name(), 
        $sformatf("Collected: data=0x%0h", trans.data), 
        UVM_HIGH)
    end
  endtask
endclass

// Custom environment
class my_env extends uvm_base_env #(my_transaction);
  `uvm_component_utils(my_env)
  
  function new(string name = "my_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_type_name(), "Building custom environment", UVM_LOW)
  endfunction
endclass

// Test
class my_test extends uvm_test;
  `uvm_component_utils(my_test)
  
  my_env env;
  
  function new(string name = "my_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = my_env::type_id::create("env", this);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    my_sequence seq;
    
    phase.raise_objection(this);
    
    `uvm_info(get_type_name(), "Test starting", UVM_LOW)
    
    seq = my_sequence::type_id::create("seq");
    seq.start(env.agent.sequencer);
    
    #1000;  // Wait for completion
    
    `uvm_info(get_type_name(), "Test complete", UVM_LOW)
    
    phase.drop_objection(this);
  endtask
  
  virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(get_type_name(), "Test finished successfully", UVM_LOW)
  endfunction
endclass

// Top module
module testbench_top;
  
  // Clock generation
  logic clk = 0;
  always #5 clk = ~clk;
  
  // Interface instance
  dut_if dut_if_inst();
  
  // Connect clock
  assign dut_if_inst.clk = clk;
  
  // DUT instance (placeholder)
  // my_dut dut (
  //   .clk(dut_if_inst.clk),
  //   .reset_n(dut_if_inst.reset_n),
  //   ...
  // );
  
  initial begin
    // Set interface in config DB
    uvm_config_db#(virtual dut_if)::set(null, "*", "vif", dut_if_inst);
    
    // Run test
    run_test("my_test");
  end
  
  // Waveform dump
  initial begin
    $dumpfile("testbench.vcd");
    $dumpvars(0, testbench_top);
  end
  
endmodule

`endif // UVM_TESTBENCH_EXAMPLE_SV
