"""
Validation utilities module.
"""

import re
from typing import Optional


def validate_email(email: str) -> bool:
    """
    Validate email address format.

    Args:
        email: Email address to validate

    Returns:
        True if email is valid, False otherwise
    """
    pattern = r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
    return bool(re.match(pattern, email))


def validate_phone(phone: str) -> bool:
    """
    Validate US phone number format.

    Args:
        phone: Phone number to validate

    Returns:
        True if phone number is valid, False otherwise
    """
    pattern = r"^\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$"
    return bool(re.match(pattern, phone))


def sanitize_input(user_input: str, max_length: int = 255) -> Optional[str]:
    """
    Sanitize user input by removing potentially dangerous characters.

    Args:
        user_input: Raw user input
        max_length: Maximum allowed length

    Returns:
        Sanitized input or None if invalid
    """
    if not user_input or len(user_input) > max_length:
        return None

    # Remove potential SQL injection characters
    dangerous_chars = ["'", '"', ";", "--", "/*", "*/"]
    sanitized = user_input

    for char in dangerous_chars:
        sanitized = sanitized.replace(char, "")

    return sanitized.strip()


def validate_password_strength(password: str) -> tuple[bool, str]:
    """
    Validate password strength.

    Args:
        password: Password to validate

    Returns:
        Tuple of (is_valid, message)
    """
    if len(password) < 8:
        return False, "Password must be at least 8 characters long"

    if not re.search(r"[A-Z]", password):
        return False, "Password must contain at least one uppercase letter"

    if not re.search(r"[a-z]", password):
        return False, "Password must contain at least one lowercase letter"

    if not re.search(r"[0-9]", password):
        return False, "Password must contain at least one digit"

    if not re.search(r'[!@#$%^&*(),.?":{}|<>]', password):
        return False, "Password must contain at least one special character"

    return True, "Password is strong"
