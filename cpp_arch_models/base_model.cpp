/**
 * @file base_model.cpp
 * @brief Implementation of base architecture model classes
 */

#include "base_model.h"
#include <stdexcept>
#include <iostream>

namespace arch_models {

// BaseModel Implementation
BaseModel::BaseModel(const std::string& name)
    : name_(name), initialized_(false), cycle_count_(0) {
}

// Register Implementation
Register::Register(const std::string& name, uint32_t width, uint32_t reset_value)
    : name_(name), width_(width), value_(reset_value), reset_value_(reset_value) {
    if (width == 0 || width > 32) {
        throw std::invalid_argument("Register width must be between 1 and 32");
    }
}

void Register::write(uint32_t value) {
    // Mask to register width
    uint32_t mask = (width_ == 32) ? 0xFFFFFFFF : ((1u << width_) - 1);
    value_ = value & mask;
}

uint32_t Register::read() const {
    return value_;
}

void Register::reset() {
    value_ = reset_value_;
}

// Bus Implementation
Bus::Bus(const std::string& name, uint32_t addr_width, uint32_t data_width)
    : name_(name), addr_width_(addr_width), data_width_(data_width) {
}

bool Bus::write(uint64_t addr, uint32_t data) {
    Transaction txn;
    txn.address = addr;
    txn.data = data;
    txn.is_write = true;
    txn.is_valid = true;
    txn.timestamp = transaction_queue_.size();
    
    transaction_queue_.push_back(txn);
    return true;
}

bool Bus::read(uint64_t addr, uint32_t& data) {
    Transaction txn;
    txn.address = addr;
    txn.data = 0;
    txn.is_write = false;
    txn.is_valid = true;
    txn.timestamp = transaction_queue_.size();
    
    transaction_queue_.push_back(txn);
    
    // Simplified: return dummy data
    data = 0xDEADBEEF;
    return true;
}

} // namespace arch_models
