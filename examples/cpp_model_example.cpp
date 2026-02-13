/**
 * Example: C++ Architecture Model Usage
 * Demonstrates processor model instantiation and usage
 */

#include "../cpp_arch_models/processor_model.h"
#include <iostream>
#include <iomanip>

void print_separator() {
    std::cout << std::string(60, '=') << std::endl;
}

void print_registers(const arch_models::ProcessorModel& cpu) {
    std::cout << "\nRegister State:" << std::endl;
    for (int i = 0; i < 8; i++) {
        std::cout << "  R" << i << ": 0x" 
                  << std::hex << std::setw(8) << std::setfill('0')
                  << cpu.read_register(i) << std::endl;
    }
    std::cout << "  PC: 0x" 
              << std::hex << std::setw(8) << std::setfill('0')
              << cpu.get_pc() << std::endl;
}

int main() {
    print_separator();
    std::cout << "C++ Architecture Model Example" << std::endl;
    print_separator();
    
    // Create processor model
    arch_models::ProcessorModel cpu("CPU0");
    
    std::cout << "\n1. Initializing processor model..." << std::endl;
    cpu.initialize();
    
    // Write some test data to registers
    std::cout << "\n2. Writing test data to registers..." << std::endl;
    cpu.write_register(1, 0x100);
    cpu.write_register(2, 0x200);
    cpu.write_register(3, 0x300);
    
    print_registers(cpu);
    
    // Write instruction to memory
    std::cout << "\n3. Loading test program to memory..." << std::endl;
    // Simple ADD instruction: R4 = R1 + R2
    uint32_t add_instruction = 0x00221820;  // ADD R4, R1, R2
    cpu.write_memory(0, add_instruction);
    
    std::cout << "  Loaded instruction at 0x0000: ADD R4, R1, R2" << std::endl;
    
    // Execute steps
    std::cout << "\n4. Executing instructions..." << std::endl;
    cpu.set_pc(0);
    
    for (int i = 0; i < 3; i++) {
        std::cout << "\n  Cycle " << i << ":" << std::endl;
        std::cout << "    PC before: 0x" << std::hex << cpu.get_pc() << std::endl;
        cpu.step();
        std::cout << "    PC after:  0x" << std::hex << cpu.get_pc() << std::endl;
    }
    
    print_registers(cpu);
    
    // Test memory operations
    std::cout << "\n5. Testing memory operations..." << std::endl;
    uint32_t test_addr = 0x100;  // Within 4KB range
    uint32_t test_data = 0xDEADBEEF;
    
    cpu.write_memory(test_addr, test_data);
    uint32_t read_data = cpu.read_memory(test_addr);
    
    std::cout << "  Write to 0x" << std::hex << test_addr 
              << ": 0x" << test_data << std::endl;
    std::cout << "  Read from 0x" << std::hex << test_addr 
              << ": 0x" << read_data << std::endl;
    
    if (read_data == test_data) {
        std::cout << "  ✓ Memory read/write test PASSED" << std::endl;
    } else {
        std::cout << "  ✗ Memory read/write test FAILED" << std::endl;
    }
    
    // Reset test
    std::cout << "\n6. Testing reset functionality..." << std::endl;
    cpu.reset();
    print_registers(cpu);
    
    print_separator();
    std::cout << "✓ C++ Architecture Model example complete" << std::endl;
    print_separator();
    
    return 0;
}
