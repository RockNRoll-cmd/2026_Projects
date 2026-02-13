# UVM Components

This directory contains Universal Verification Methodology (UVM) base components for SystemVerilog testbenches.

## Components

### uvm_base_driver
Generic UVM driver that:
- Fetches sequence items from sequencer
- Drives transactions on DUT interface
- Handles reset conditions
- Can be parameterized with transaction types

### uvm_base_monitor
Generic UVM monitor that:
- Observes DUT interface
- Collects transactions
- Broadcasts via analysis port
- Includes coverage support
- Protocol checking capability

### uvm_base_agent
Generic UVM agent containing:
- Driver (active mode only)
- Sequencer (active mode only)
- Monitor (always present)
- Configurable active/passive mode

### uvm_base_scoreboard
Generic scoreboard for checking:
- Transaction comparison
- Expected vs actual tracking
- Match/mismatch statistics
- Comprehensive reporting
- Configurable comparison functions

### uvm_base_env
Top-level environment that:
- Instantiates agent and scoreboard
- Connects components
- Manages configuration
- Provides topology printing

## Usage

### Compilation

```bash
# Compile with your simulator (example with VCS)
vcs -sverilog +incdir+$UVM_HOME/src \
    $UVM_HOME/src/uvm_pkg.sv \
    uvm_components_pkg.sv \
    -full64 -debug_access+all
```

### Creating Custom Components

```systemverilog
// Custom transaction
class my_transaction extends uvm_sequence_item;
  rand bit [7:0] data;
  rand bit [15:0] addr;
  `uvm_object_utils(my_transaction)
endclass

// Custom driver
class my_driver extends uvm_base_driver#(my_transaction);
  `uvm_component_utils(my_driver)
  
  virtual task drive_item(my_transaction req);
    @(posedge vif.clk);
    vif.data <= req.data;
    vif.addr <= req.addr;
    vif.valid <= 1'b1;
    @(posedge vif.clk);
    vif.valid <= 1'b0;
  endtask
endclass

// Instantiate in environment
my_driver driver;
driver = my_driver::type_id::create("driver", this);
```

## Features

- **Parameterized Components**: Support for custom transaction types
- **Flexible Architecture**: Easy to extend and customize
- **Built-in Checking**: Scoreboard with automatic comparison
- **Coverage Ready**: Monitor includes coverage infrastructure
- **Protocol Checking**: Framework for protocol compliance
- **Comprehensive Reporting**: Detailed phase reports

## Directory Structure

```
uvm_components/
├── uvm_base_driver.sv       # Driver component
├── uvm_base_monitor.sv      # Monitor component
├── uvm_base_agent.sv        # Agent component
├── uvm_base_scoreboard.sv   # Scoreboard component
├── uvm_base_env.sv          # Environment component
├── uvm_components_pkg.sv    # Package file
└── README.md                # This file
```
