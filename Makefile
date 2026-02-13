# Makefile for 2026 Verification Infrastructure

.PHONY: all clean test test-ai test-cpp help

# Default target
all: help

# Help target
help:
	@echo "2026 Verification Infrastructure - Build Targets"
	@echo "================================================"
	@echo ""
	@echo "Available targets:"
	@echo "  make test          - Run all tests"
	@echo "  make test-ai       - Run AI agents example"
	@echo "  make test-cpp      - Build and run C++ model example"
	@echo "  make build-cpp     - Build C++ examples only"
	@echo "  make clean         - Clean build artifacts"
	@echo "  make help          - Show this help message"
	@echo ""
	@echo "Examples:"
	@echo "  cd examples && python ai_verification_example.py"
	@echo "  cd examples && ./cpp_example"
	@echo ""

# Run all tests
test: test-ai test-cpp

# Test AI agents
test-ai:
	@echo "Running AI Verification Example..."
	@cd examples && python ai_verification_example.py
	@echo ""

# Build C++ examples
build-cpp:
	@echo "Building C++ Model Example..."
	@cd examples && g++ -std=c++17 -I.. \
		cpp_model_example.cpp \
		../cpp_arch_models/base_model.cpp \
		../cpp_arch_models/processor_model.cpp \
		-o cpp_example
	@echo "Build complete: examples/cpp_example"
	@echo ""

# Test C++ models
test-cpp: build-cpp
	@echo "Running C++ Model Example..."
	@cd examples && ./cpp_example
	@echo ""

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	@rm -f examples/cpp_example
	@rm -f examples/*.o
	@rm -f cpp_arch_models/*.o
	@find . -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true
	@find . -name "*.pyc" -delete 2>/dev/null || true
	@echo "Clean complete"
	@echo ""

# Check code structure
check:
	@echo "Project Structure:"
	@echo "=================="
	@find . -type f \( -name "*.py" -o -name "*.cpp" -o -name "*.h" -o -name "*.sv" \) \
		-not -path "./.git/*" | sort
	@echo ""
	@echo "Statistics:"
	@echo "==========="
	@echo "Python files: $$(find . -name "*.py" -not -path "./.git/*" | wc -l)"
	@echo "C++ source files: $$(find . -name "*.cpp" -not -path "./.git/*" | wc -l)"
	@echo "C++ header files: $$(find . -name "*.h" -not -path "./.git/*" | wc -l)"
	@echo "SystemVerilog files: $$(find . -name "*.sv" -not -path "./.git/*" | wc -l)"
	@echo "README files: $$(find . -name "README.md" -not -path "./.git/*" | wc -l)"
	@echo ""
