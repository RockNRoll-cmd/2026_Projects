/**
 * @file processor_model.cpp
 * @brief Implementation of simple processor model
 */

#include "processor_model.h"
#include <stdexcept>
#include <cstring>
#include <iostream>

namespace arch_models {

ProcessorModel::ProcessorModel(const std::string& name)
    : BaseModel(name), pc_(0) {
    registers_.fill(0);
    memory_.fill(0);
}

void ProcessorModel::initialize() {
    if (initialized_) {
        return;
    }
    
    reset();
    initialized_ = true;
    
    std::cout << "ProcessorModel '" << name_ << "' initialized" << std::endl;
}

void ProcessorModel::reset() {
    registers_.fill(0);
    memory_.fill(0);
    pc_ = 0;
    cycle_count_ = 0;
    
    std::cout << "ProcessorModel '" << name_ << "' reset" << std::endl;
}

void ProcessorModel::step() {
    if (!initialized_) {
        throw std::runtime_error("Model not initialized");
    }
    
    // Fetch instruction from memory
    uint32_t instruction = read_memory(pc_);
    
    // Execute instruction
    execute_instruction(instruction);
    
    // Increment PC (simplified - doesn't handle branches)
    pc_ += 4;
    
    cycle_count_++;
}

uint32_t ProcessorModel::read_register(uint8_t reg_id) const {
    if (reg_id >= NUM_REGISTERS) {
        throw std::out_of_range("Register ID out of range");
    }
    
    // Register 0 is always 0 in RISC architectures
    if (reg_id == 0) {
        return 0;
    }
    
    return registers_[reg_id];
}

void ProcessorModel::write_register(uint8_t reg_id, uint32_t value) {
    if (reg_id >= NUM_REGISTERS) {
        throw std::out_of_range("Register ID out of range");
    }
    
    // Register 0 cannot be written in RISC architectures
    if (reg_id == 0) {
        return;
    }
    
    registers_[reg_id] = value;
}

uint32_t ProcessorModel::read_memory(uint32_t addr) const {
    if (addr >= MEMORY_SIZE - 3) {
        throw std::out_of_range("Memory address out of range");
    }
    
    // Read 32-bit word (little-endian)
    uint32_t value = 0;
    value |= memory_[addr];
    value |= memory_[addr + 1] << 8;
    value |= memory_[addr + 2] << 16;
    value |= memory_[addr + 3] << 24;
    
    return value;
}

void ProcessorModel::write_memory(uint32_t addr, uint32_t value) {
    if (addr >= MEMORY_SIZE - 3) {
        throw std::out_of_range("Memory address out of range");
    }
    
    // Write 32-bit word (little-endian)
    memory_[addr] = value & 0xFF;
    memory_[addr + 1] = (value >> 8) & 0xFF;
    memory_[addr + 2] = (value >> 16) & 0xFF;
    memory_[addr + 3] = (value >> 24) & 0xFF;
}

void ProcessorModel::execute_instruction(uint32_t instruction) {
    // Simplified instruction decode and execute
    // This is a placeholder for actual instruction execution
    
    uint8_t opcode = (instruction >> 26) & 0x3F;
    
    // Example: Simple ADD instruction
    if (opcode == 0x00) {
        uint8_t rd = (instruction >> 11) & 0x1F;
        uint8_t rs = (instruction >> 21) & 0x1F;
        uint8_t rt = (instruction >> 16) & 0x1F;
        
        uint32_t result = read_register(rs) + read_register(rt);
        write_register(rd, result);
    }
    // Add more instruction implementations here
}

void ProcessorModel::decode_and_execute(uint32_t instruction) {
    execute_instruction(instruction);
}

} // namespace arch_models
