/**
 * @file base_model.h
 * @brief Base Architecture Model for C++ Based Verification
 */

#ifndef BASE_MODEL_H
#define BASE_MODEL_H

#include <string>
#include <vector>
#include <memory>
#include <map>

namespace arch_models {

/**
 * @class BaseModel
 * @brief Abstract base class for all architecture models
 */
class BaseModel {
public:
    /**
     * @brief Constructor
     * @param name Model instance name
     */
    explicit BaseModel(const std::string& name);
    
    /**
     * @brief Virtual destructor
     */
    virtual ~BaseModel() = default;
    
    /**
     * @brief Initialize the model
     */
    virtual void initialize() = 0;
    
    /**
     * @brief Reset the model to initial state
     */
    virtual void reset() = 0;
    
    /**
     * @brief Execute one cycle/step of the model
     */
    virtual void step() = 0;
    
    /**
     * @brief Get model name
     * @return Model name
     */
    const std::string& get_name() const { return name_; }
    
    /**
     * @brief Check if model is initialized
     * @return true if initialized
     */
    bool is_initialized() const { return initialized_; }
    
protected:
    std::string name_;
    bool initialized_;
    uint64_t cycle_count_;
};

/**
 * @class Register
 * @brief Generic register model
 */
class Register {
public:
    Register(const std::string& name, uint32_t width, uint32_t reset_value = 0);
    
    void write(uint32_t value);
    uint32_t read() const;
    void reset();
    
    const std::string& get_name() const { return name_; }
    uint32_t get_width() const { return width_; }
    
private:
    std::string name_;
    uint32_t width_;
    uint32_t value_;
    uint32_t reset_value_;
};

/**
 * @class Bus
 * @brief Generic bus interface model
 */
class Bus {
public:
    struct Transaction {
        uint64_t address;
        uint32_t data;
        bool is_write;
        bool is_valid;
        uint32_t timestamp;
    };
    
    Bus(const std::string& name, uint32_t addr_width, uint32_t data_width);
    
    bool write(uint64_t addr, uint32_t data);
    bool read(uint64_t addr, uint32_t& data);
    
    const std::string& get_name() const { return name_; }
    
private:
    std::string name_;
    uint32_t addr_width_;
    uint32_t data_width_;
    std::vector<Transaction> transaction_queue_;
};

} // namespace arch_models

#endif // BASE_MODEL_H
