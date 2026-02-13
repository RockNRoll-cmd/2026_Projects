# Examples

This directory contains example code demonstrating the integration and usage of the verification components.

## Available Examples

### 1. AI Verification Example (`ai_verification_example.py`)

Demonstrates the AI agents in action:
- **Verification Agent**: Analyzes test results and identifies patterns
- **Coverage Agent**: Analyzes coverage gaps and suggests tests
- **Debug Agent**: Performs root cause analysis of failures

**Run:**
```bash
cd examples
python ai_verification_example.py
```

**Features:**
- Simulated test data analysis
- Pattern recognition in failures
- Coverage gap identification
- Automated test suggestions
- Debug recommendations

### 2. C++ Model Example (`cpp_model_example.cpp`)

Shows how to use the C++ architecture models:
- Processor initialization and reset
- Register read/write operations
- Memory operations
- Instruction execution
- State observation

**Build and Run:**
```bash
cd examples
g++ -std=c++17 -I.. cpp_model_example.cpp \
    ../cpp_arch_models/base_model.cpp \
    ../cpp_arch_models/processor_model.cpp \
    -o cpp_example
./cpp_example
```

**Demonstrates:**
- Model instantiation
- Register manipulation
- Memory access
- Instruction execution
- Reset functionality

### 3. UVM Testbench Example (`uvm_testbench_example.sv`)

Complete UVM testbench demonstrating:
- Custom transaction definition
- Sequence creation
- Driver implementation
- Monitor implementation
- Environment setup
- Test execution

**Compile and Run:**
```bash
# With VCS
vcs -sverilog +incdir+$UVM_HOME/src \
    $UVM_HOME/src/uvm_pkg.sv \
    uvm_testbench_example.sv \
    -full64 -debug_access+all
./simv

# With Questa
vlog +incdir+$UVM_HOME/src \
    $UVM_HOME/src/uvm_pkg.sv \
    uvm_testbench_example.sv
vsim -c testbench_top -do "run -all; quit"
```

**Shows:**
- Component extension
- Configuration database usage
- Phase callbacks
- Analysis port connections
- Testbench topology

## Integration Examples

### AI + C++ Integration

The AI agents can analyze C++ model behavior:

```python
from ai_agents import DebugAgent

# Analyze C++ model failure
debug_agent = DebugAgent("CPP_Debugger")
failure_data = {
    "error_message": "Memory access violation at 0x2000",
    "traceback": ["processor_model.cpp:245"],
    "context": {"pc": "0x1FFC"}
}
analysis = debug_agent.analyze(failure_data)
```

### C++ + UVM Integration

C++ models can be wrapped in DPI for UVM:

```systemverilog
// In UVM testbench
import "DPI-C" function void cpp_model_step();
import "DPI-C" function int cpp_model_read_reg(int reg_id);

class cpp_model_wrapper extends uvm_component;
  task run_phase(uvm_phase phase);
    cpp_model_step();
    data = cpp_model_read_reg(1);
  endtask
endclass
```

### Complete Verification Flow

```
┌─────────────┐
│  AI Agents  │ ─── Analysis & Intelligence
└──────┬──────┘
       │
       v
┌─────────────┐
│ C++ Models  │ ─── Architecture Models
└──────┬──────┘
       │
       v
┌─────────────┐
│ UVM/SV TB   │ ─── Verification Environment
└─────────────┘
```

## Running All Examples

```bash
# AI Agents
cd examples
python ai_verification_example.py

# C++ Models
g++ -std=c++17 -I.. cpp_model_example.cpp \
    ../cpp_arch_models/*.cpp -o cpp_example
./cpp_example

# UVM (requires simulator)
# vcs/questa command as shown above
```

## Expected Output

### AI Verification Example
- Test analysis with pass/fail
- Coverage metrics and gaps
- Debug recommendations
- AI agent status

### C++ Model Example
- Initialization messages
- Register state dumps
- Memory test results
- Execution traces

### UVM Testbench Example
- UVM phase messages
- Transaction logging
- Topology printout
- Test results

## Customization

All examples can be customized:

1. **AI Agents**: Modify decision logic and patterns
2. **C++ Models**: Add custom instructions and behaviors
3. **UVM TB**: Extend with protocol-specific agents

## Notes

- UVM examples require a SystemVerilog simulator (VCS, Questa, etc.)
- C++ examples use C++17 standard
- Python examples require Python 3.7+
- All examples are self-contained and documented
