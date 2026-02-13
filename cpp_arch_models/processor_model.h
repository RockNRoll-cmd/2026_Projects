/**
 * @file processor_model.h
 * @brief Simple Processor Architecture Model
 */

#ifndef PROCESSOR_MODEL_H
#define PROCESSOR_MODEL_H

#include "base_model.h"
#include <array>

namespace arch_models {

/**
 * @class ProcessorModel
 * @brief Simple RISC processor model for verification
 */
class ProcessorModel : public BaseModel {
public:
    static constexpr size_t NUM_REGISTERS = 32;
    static constexpr size_t MEMORY_SIZE = 4096;
    
    ProcessorModel(const std::string& name);
    ~ProcessorModel() override = default;
    
    void initialize() override;
    void reset() override;
    void step() override;
    
    // Register access
    uint32_t read_register(uint8_t reg_id) const;
    void write_register(uint8_t reg_id, uint32_t value);
    
    // Memory access
    uint32_t read_memory(uint32_t addr) const;
    void write_memory(uint32_t addr, uint32_t value);
    
    // Program counter
    uint32_t get_pc() const { return pc_; }
    void set_pc(uint32_t pc) { pc_ = pc; }
    
    // Execute instruction
    void execute_instruction(uint32_t instruction);
    
private:
    std::array<uint32_t, NUM_REGISTERS> registers_;
    std::array<uint8_t, MEMORY_SIZE> memory_;
    uint32_t pc_;  // Program counter
    
    void decode_and_execute(uint32_t instruction);
};

} // namespace arch_models

#endif // PROCESSOR_MODEL_H
