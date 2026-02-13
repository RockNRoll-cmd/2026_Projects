# SystemVerilog Verification Agents

This directory contains protocol-specific SystemVerilog verification agents for common interfaces.

## Available Agents

### AXI4-Lite Agent
Full-featured AXI4-Lite protocol agent with:
- Transaction class with all AXI4-Lite channels
- Driver supporting read and write operations
- Monitor for transaction observation
- Address alignment constraints
- Write strobe validation
- Response checking

**Features:**
- 32-bit address and data support
- Full handshake protocol implementation
- Randomizable transactions
- UVM analysis port integration

### APB Agent
AMBA APB (Advanced Peripheral Bus) agent including:
- Transaction class for APB protocol
- Driver implementing IDLE-SETUP-ACCESS phases
- Monitor for protocol observation
- Support for pready wait states
- Error response handling (pslverr)
- Protection signal support (pprot)

**Features:**
- Configurable address and data widths
- Automatic state machine handling
- Aligned address constraints
- Full UVM integration

### UART Agent
Universal Asynchronous Receiver/Transmitter agent with:
- Configurable baud rate
- Adjustable data bits (default 8)
- Configurable stop bits
- Parity support (even/odd/none)
- Error detection (parity, frame errors)

**Features:**
- Bit-accurate timing
- Automatic parity calculation
- Error injection capability
- Protocol checking

## Usage

### Compilation

```bash
# Compile with UVM
vcs -sverilog +incdir+$UVM_HOME/src \
    $UVM_HOME/src/uvm_pkg.sv \
    axi4_lite_agent.sv \
    apb_agent.sv \
    uart_agent.sv \
    -full64 -debug_access+all
```

### Example: AXI4-Lite Agent

```systemverilog
// In your testbench
class my_env extends uvm_env;
  axi4_lite_driver driver;
  axi4_lite_monitor monitor;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    driver = axi4_lite_driver::type_id::create("driver", this);
    monitor = axi4_lite_monitor::type_id::create("monitor", this);
  endfunction
endclass

// In your test
class my_test extends uvm_test;
  virtual task run_phase(uvm_phase phase);
    axi4_lite_transaction trans;
    
    phase.raise_objection(this);
    
    // Write transaction
    trans = axi4_lite_transaction::type_id::create("trans");
    trans.is_write = 1;
    trans.awaddr = 32'h1000;
    trans.wdata = 32'hDEADBEEF;
    // Send to sequencer...
    
    phase.drop_objection(this);
  endtask
endclass
```

### Example: APB Agent

```systemverilog
// APB write
apb_transaction trans = apb_transaction::type_id::create("trans");
trans.pwrite = 1'b1;
trans.paddr = 32'h2000;
trans.pwdata = 32'h12345678;

// APB read
trans.pwrite = 1'b0;
trans.paddr = 32'h2004;
```

### Example: UART Agent

```systemverilog
// Configure UART
uart_transaction trans = uart_transaction::type_id::create("trans");
trans.baud_rate = 115200;
trans.data_bits = 8;
trans.stop_bits = 1;
trans.parity_enable = 1;
trans.parity_odd = 0;  // Even parity
trans.data = 8'hA5;
```

## Interface Requirements

Each agent requires a corresponding interface:

### AXI4-Lite Interface
```systemverilog
interface axi4_lite_if;
  logic aclk;
  logic aresetn;
  logic [31:0] awaddr;
  logic [2:0] awprot;
  logic awvalid;
  logic awready;
  // ... (all AXI4-Lite signals)
endinterface
```

### APB Interface
```systemverilog
interface apb_if;
  logic pclk;
  logic presetn;
  logic [31:0] paddr;
  logic psel;
  logic penable;
  logic pwrite;
  // ... (all APB signals)
endinterface
```

### UART Interface
```systemverilog
interface uart_if;
  logic tx;
  logic rx;
endinterface
```

## Features

- **Protocol Compliance**: All agents follow industry-standard protocols
- **Configurable**: Timing and protocol parameters are configurable
- **Error Detection**: Built-in protocol violation checking
- **UVM Compatible**: Full UVM integration with TLM ports
- **Reusable**: Can be instantiated multiple times in same environment
- **Extensible**: Easy to extend for custom requirements

## Directory Structure

```
sv_verif_agents/
├── axi4_lite_agent.sv    # AXI4-Lite protocol agent
├── apb_agent.sv          # APB protocol agent
├── uart_agent.sv         # UART protocol agent
└── README.md             # This file
```
