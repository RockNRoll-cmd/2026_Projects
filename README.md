# 2026 Verification Infrastructure

A comprehensive verification infrastructure featuring AI Agents, C++ Architecture Models, UVM Components, and SystemVerilog Verification Agents for advanced hardware verification.

## Features

### 🤖 AI Agents
Intelligent verification agents for automated analysis:
- **Verification Agent**: Test result analysis and pattern recognition
- **Coverage Agent**: Gap analysis and test generation suggestions
- **Debug Agent**: Root cause analysis and debug recommendations

### 🔧 C++ Architecture Models
High-performance architectural models:
- **BaseModel**: Abstract base class for all models
- **ProcessorModel**: RISC processor with 32 registers and 4KB memory
- **Register & Bus**: Reusable components for custom models

### 🔬 UVM Components
Universal Verification Methodology base components:
- **Driver, Monitor, Agent**: Parameterized, reusable components
- **Scoreboard**: Transaction comparison and statistics
- **Environment**: Top-level testbench container

### 🚀 SystemVerilog Verification Agents
Protocol-specific verification agents:
- **AXI4-Lite Agent**: Full AXI4-Lite protocol support
- **APB Agent**: AMBA APB protocol verification
- **UART Agent**: Configurable UART with error detection

## Quick Start

### AI Agents Example
```python
from ai_agents import VerificationAgent, CoverageAgent

# Analyze test results
verif_agent = VerificationAgent()
analysis = verif_agent.analyze(test_data)
decision = verif_agent.decide(analysis)

# Analyze coverage
cov_agent = CoverageAgent()
cov_analysis = cov_agent.analyze(coverage_data)
suggestions = cov_agent.suggest_tests(cov_analysis)
```

### C++ Models Example
```cpp
#include "cpp_arch_models/processor_model.h"

arch_models::ProcessorModel cpu("CPU0");
cpu.initialize();
cpu.write_register(1, 0x100);
cpu.step();  // Execute one cycle
```

### UVM Testbench Example
```systemverilog
import uvm_components_pkg::*;

class my_env extends uvm_base_env #(my_transaction);
  // Automatically includes driver, monitor, scoreboard
endclass
```

### SV Verification Agent Example
```systemverilog
// AXI4-Lite write
axi4_lite_transaction trans;
trans.is_write = 1;
trans.awaddr = 32'h1000;
trans.wdata = 32'hDEADBEEF;
```

## Directory Structure

```
2026_Projects/
├── ai_agents/              # AI verification agents (Python)
│   ├── base_agent.py
│   ├── verification_agent.py
│   ├── coverage_agent.py
│   └── debug_agent.py
├── cpp_arch_models/        # C++ architecture models
│   ├── base_model.h/cpp
│   └── processor_model.h/cpp
├── uvm_components/         # UVM base components (SystemVerilog)
│   ├── uvm_base_driver.sv
│   ├── uvm_base_monitor.sv
│   ├── uvm_base_agent.sv
│   ├── uvm_base_scoreboard.sv
│   └── uvm_base_env.sv
├── sv_verif_agents/        # Protocol verification agents (SystemVerilog)
│   ├── axi4_lite_agent.sv
│   ├── apb_agent.sv
│   └── uart_agent.sv
├── examples/               # Usage examples
│   ├── ai_verification_example.py
│   ├── cpp_model_example.cpp
│   └── uvm_testbench_example.sv
└── docs/                   # Documentation
    └── ARCHITECTURE.md
```

## Getting Started

### Prerequisites

- **Python 3.7+** for AI agents
- **C++17 compiler** (g++, clang) for C++ models
- **SystemVerilog simulator** (VCS, Questa, Xcelium) for UVM/SV components

### Running Examples

#### AI Agents
```bash
cd examples
python ai_verification_example.py
```

#### C++ Models
```bash
cd examples
g++ -std=c++17 -I.. cpp_model_example.cpp \
    ../cpp_arch_models/*.cpp -o cpp_example
./cpp_example
```

#### UVM Testbench
```bash
# With VCS
vcs -sverilog +incdir+$UVM_HOME/src \
    $UVM_HOME/src/uvm_pkg.sv \
    examples/uvm_testbench_example.sv
./simv

# With Questa
vlog +incdir+$UVM_HOME/src examples/uvm_testbench_example.sv
vsim -c testbench_top -do "run -all; quit"
```

## Documentation

- [Architecture Overview](docs/ARCHITECTURE.md) - Detailed architecture and design
- [AI Agents README](ai_agents/README.md) - AI agents documentation
- [C++ Models README](cpp_arch_models/README.md) - C++ models guide
- [UVM Components README](uvm_components/README.md) - UVM components usage
- [SV Agents README](sv_verif_agents/README.md) - Protocol agents reference
- [Examples README](examples/README.md) - Example code walkthrough

## Use Cases

### 1. Standard Protocol Verification
Use pre-built agents (AXI, APB, UART) with UVM testbench for quick setup.

### 2. Custom Protocol Verification
Extend UVM base components to create custom protocol agents.

### 3. Architecture Exploration
Use C++ models for early architecture verification before RTL.

### 4. Intelligent Debugging
Use AI agents to analyze failures and suggest root causes.

### 5. Coverage-Driven Verification
Use Coverage Agent to identify gaps and generate targeted tests.

## Integration

### AI + UVM
```python
# Analyze UVM test results
verif_agent.analyze({
    "test_status": "fail",
    "failures": [...],
    "coverage": 75.5
})
```

### C++ + UVM (via DPI)
```systemverilog
import "DPI-C" function void cpp_model_step();
import "DPI-C" function int cpp_read_reg(int id);
```

### Complete Flow
```
Stimulus → UVM Driver → DUT
                     ↓
               UVM Monitor → Scoreboard
                     ↓            ↓
               C++ Model → AI Agents
```

## Contributing

Contributions are welcome! This infrastructure is designed to be:
- **Modular**: Add new agents or models independently
- **Extensible**: Extend base classes for custom needs
- **Reusable**: Use components across different projects

## License

This project is provided as-is for verification and educational purposes.

## Support

- Check [examples/](examples/) for usage patterns
- Review [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for design details
- Each component directory has its own README with specific documentation
