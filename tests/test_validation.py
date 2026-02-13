"""
Unit tests for validation module.
"""

from src.validation import (
    sanitize_input,
    validate_email,
    validate_password_strength,
    validate_phone,
)


class TestEmailValidation:
    """Test cases for email validation."""

    def test_valid_emails(self):
        """Test valid email formats."""
        assert validate_email("user@example.com") is True
        assert validate_email("john.doe@company.co.uk") is True
        assert validate_email("test+tag@domain.com") is True

    def test_invalid_emails(self):
        """Test invalid email formats."""
        assert validate_email("invalid.email") is False
        assert validate_email("@example.com") is False
        assert validate_email("user@") is False
        assert validate_email("") is False


class TestPhoneValidation:
    """Test cases for phone number validation."""

    def test_valid_phone_numbers(self):
        """Test valid US phone number formats."""
        assert validate_phone("(123) 456-7890") is True
        assert validate_phone("123-456-7890") is True
        assert validate_phone("123.456.7890") is True
        assert validate_phone("1234567890") is True

    def test_invalid_phone_numbers(self):
        """Test invalid phone number formats."""
        assert validate_phone("12-345-6789") is False
        assert validate_phone("123-456-789") is False
        assert validate_phone("abc-def-ghij") is False
        assert validate_phone("") is False


class TestInputSanitization:
    """Test cases for input sanitization."""

    def test_clean_input(self):
        """Test sanitization of clean input."""
        result = sanitize_input("Hello World")
        assert result == "Hello World"

    def test_sql_injection_attempt(self):
        """Test sanitization removes SQL injection characters."""
        result = sanitize_input("admin' OR '1'='1")
        assert "'" not in result
        assert result == "admin OR 1=1"

    def test_script_injection_attempt(self):
        """Test sanitization of potentially malicious input."""
        result = sanitize_input("test; DROP TABLE users;")
        assert ";" not in result
        assert "--" not in result

    def test_max_length_exceeded(self):
        """Test input exceeding max length returns None."""
        long_input = "a" * 300
        result = sanitize_input(long_input, max_length=255)
        assert result is None

    def test_empty_input(self):
        """Test empty input returns None."""
        result = sanitize_input("")
        assert result is None


class TestPasswordStrength:
    """Test cases for password strength validation."""

    def test_strong_password(self):
        """Test strong password validation."""
        is_valid, message = validate_password_strength("StrongP@ss123")
        assert is_valid is True
        assert "strong" in message.lower()

    def test_short_password(self):
        """Test password too short."""
        is_valid, message = validate_password_strength("Sh0rt!")
        assert is_valid is False
        assert "8 characters" in message

    def test_no_uppercase(self):
        """Test password without uppercase."""
        is_valid, message = validate_password_strength("weakpass123!")
        assert is_valid is False
        assert "uppercase" in message.lower()

    def test_no_lowercase(self):
        """Test password without lowercase."""
        is_valid, message = validate_password_strength("WEAKPASS123!")
        assert is_valid is False
        assert "lowercase" in message.lower()

    def test_no_digit(self):
        """Test password without digit."""
        is_valid, message = validate_password_strength("WeakPass!@#")
        assert is_valid is False
        assert "digit" in message.lower()

    def test_no_special_char(self):
        """Test password without special character."""
        is_valid, message = validate_password_strength("WeakPass123")
        assert is_valid is False
        assert "special character" in message.lower()
