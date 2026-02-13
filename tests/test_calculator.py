"""
Unit tests for calculator module.
"""

import pytest

from src.calculator import Calculator


class TestCalculator:
    """Test cases for Calculator class."""

    def setup_method(self):
        """Set up test fixtures."""
        self.calc = Calculator()

    def test_add_positive_numbers(self):
        """Test addition of positive numbers."""
        assert self.calc.add(5, 3) == 8
        assert self.calc.add(10, 20) == 30

    def test_add_negative_numbers(self):
        """Test addition with negative numbers."""
        assert self.calc.add(-5, -3) == -8
        assert self.calc.add(-5, 3) == -2

    def test_add_floats(self):
        """Test addition of float numbers."""
        assert self.calc.add(5.5, 3.2) == pytest.approx(8.7)

    def test_subtract_positive_numbers(self):
        """Test subtraction of positive numbers."""
        assert self.calc.subtract(5, 3) == 2
        assert self.calc.subtract(10, 20) == -10

    def test_subtract_negative_numbers(self):
        """Test subtraction with negative numbers."""
        assert self.calc.subtract(-5, -3) == -2
        assert self.calc.subtract(5, -3) == 8

    def test_multiply_positive_numbers(self):
        """Test multiplication of positive numbers."""
        assert self.calc.multiply(5, 3) == 15
        assert self.calc.multiply(10, 20) == 200

    def test_multiply_by_zero(self):
        """Test multiplication by zero."""
        assert self.calc.multiply(5, 0) == 0
        assert self.calc.multiply(0, 5) == 0

    def test_multiply_negative_numbers(self):
        """Test multiplication with negative numbers."""
        assert self.calc.multiply(-5, 3) == -15
        assert self.calc.multiply(-5, -3) == 15

    def test_divide_positive_numbers(self):
        """Test division of positive numbers."""
        assert self.calc.divide(6, 3) == 2.0
        assert self.calc.divide(10, 4) == 2.5

    def test_divide_negative_numbers(self):
        """Test division with negative numbers."""
        assert self.calc.divide(-6, 3) == -2.0
        assert self.calc.divide(-6, -3) == 2.0

    def test_divide_by_zero(self):
        """Test division by zero raises ValueError."""
        with pytest.raises(ValueError, match="Cannot divide by zero"):
            self.calc.divide(5, 0)

    def test_divide_zero_by_number(self):
        """Test zero divided by number."""
        assert self.calc.divide(0, 5) == 0.0
