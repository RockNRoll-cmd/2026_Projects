# Contributing to Validation and Verification Tools

Thank you for your interest in contributing! This document provides guidelines and best practices for contributing to this project.

## 🌟 Getting Started

1. Fork the repository
2. Clone your fork: `git clone https://github.com/YOUR_USERNAME/2026_Projects.git`
3. Create a new branch: `git checkout -b feature/your-feature-name`
4. Set up the development environment (see README.md)

## 📝 Development Workflow

### 1. Make Your Changes

- Write clean, readable code
- Follow the existing code style
- Add or update tests as needed
- Update documentation if required

### 2. Test Your Changes

Before committing, ensure all checks pass:

```bash
# Run tests
pytest

# Check code formatting
black --check src/ tests/

# Check import sorting
isort --check-only src/ tests/

# Run linters
flake8 src/
pylint src/

# Run type checker
mypy src/

# Run security scanner
bandit -r src/
```

### 3. Commit Your Changes

Use clear, descriptive commit messages:

```bash
git add .
git commit -m "Add feature: description of your changes"
```

Commit message format:
- Use present tense ("Add feature" not "Added feature")
- Use imperative mood ("Move cursor to..." not "Moves cursor to...")
- First line should be 50 characters or less
- Reference issues and PRs liberally in the commit body

### 4. Push and Create Pull Request

```bash
git push origin feature/your-feature-name
```

Then create a Pull Request on GitHub.

## 🔍 Code Quality Standards

### Python Style Guide

- Follow [PEP 8](https://pep8.org/)
- Maximum line length: 100 characters
- Use type hints for function signatures
- Write docstrings for all public modules, functions, classes, and methods

### Testing Standards

- Write tests for all new features
- Aim for at least 80% code coverage
- Use descriptive test names
- Follow the Arrange-Act-Assert pattern

Example:
```python
def test_calculator_adds_two_numbers():
    # Arrange
    calc = Calculator()
    
    # Act
    result = calc.add(5, 3)
    
    # Assert
    assert result == 8
```

### Documentation Standards

- Update README.md for user-facing changes
- Add docstrings to all public APIs
- Include examples in docstrings when helpful
- Keep documentation up-to-date with code changes

## 🚀 Pull Request Process

1. **Update the PR description** with:
   - What changes were made
   - Why the changes were necessary
   - Any breaking changes or migration notes

2. **Ensure all CI checks pass**:
   - All tests must pass
   - Code coverage should not decrease
   - No linting errors
   - No security vulnerabilities

3. **Request review** from maintainers

4. **Address feedback** promptly and professionally

5. **Squash commits** if requested before merging

## 🐛 Reporting Bugs

When reporting bugs, include:
- A clear, descriptive title
- Steps to reproduce the issue
- Expected behavior
- Actual behavior
- Your environment (Python version, OS, etc.)
- Any relevant error messages or logs

## 💡 Suggesting Enhancements

When suggesting enhancements:
- Use a clear, descriptive title
- Provide a detailed description of the proposed feature
- Explain why this enhancement would be useful
- Include examples of how the feature would be used

## 🔒 Security Issues

**Do not** report security vulnerabilities in public issues. Instead:
- Email the maintainers directly
- Include detailed information about the vulnerability
- Wait for a response before disclosing publicly

## 📋 Checklist

Before submitting your PR, ensure:

- [ ] Code follows the project's style guidelines
- [ ] Tests have been added/updated
- [ ] All tests pass locally
- [ ] Documentation has been updated
- [ ] Commit messages are clear and descriptive
- [ ] No new linting warnings
- [ ] No security vulnerabilities introduced
- [ ] Code coverage hasn't decreased

## 🤝 Code of Conduct

- Be respectful and inclusive
- Accept constructive criticism gracefully
- Focus on what is best for the community
- Show empathy towards other community members

## ❓ Questions?

If you have questions, feel free to:
- Open an issue for discussion
- Reach out to the maintainers
- Check existing issues and PRs for similar discussions

Thank you for contributing! 🎉
