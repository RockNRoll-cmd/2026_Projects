# C++ Architecture Models

This directory contains C++ based architecture models for hardware verification.

## Components

### BaseModel
Abstract base class providing common interface for all architecture models:
- `initialize()`: Initialize the model
- `reset()`: Reset to initial state
- `step()`: Execute one cycle

### Register
Generic register model with:
- Configurable width (1-32 bits)
- Reset value support
- Read/write operations

### Bus
Generic bus interface model supporting:
- Configurable address and data widths
- Read/write transactions
- Transaction queue

### ProcessorModel
Simple RISC processor model featuring:
- 32 general-purpose registers
- 4KB memory
- Program counter
- Basic instruction execution

## Building

```bash
# Compile the models
g++ -std=c++17 -c base_model.cpp -o base_model.o
g++ -std=c++17 -c processor_model.cpp -o processor_model.o

# Link
g++ -std=c++17 base_model.o processor_model.o -o processor_model_test
```

## Usage Example

```cpp
#include "processor_model.h"

int main() {
    arch_models::ProcessorModel cpu("CPU0");
    
    cpu.initialize();
    cpu.reset();
    
    // Write to registers
    cpu.write_register(1, 0x100);
    cpu.write_register(2, 0x200);
    
    // Execute steps
    for (int i = 0; i < 10; i++) {
        cpu.step();
    }
    
    return 0;
}
```
