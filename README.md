# Validation and Verification Tools for DevOps

This project demonstrates a comprehensive suite of validation and verification tools for DevOps practices, including continuous integration, code quality checks, security scanning, and automated testing.

## 🚀 Features

- **Automated CI/CD Pipeline**: GitHub Actions workflows for continuous integration and deployment
- **Code Quality Tools**: Linting, formatting, and static analysis
- **Security Scanning**: Vulnerability detection in code and dependencies
- **Comprehensive Testing**: Unit tests with coverage reporting
- **Code Complexity Analysis**: Maintainability and complexity metrics
- **Dependency Management**: Automated dependency vulnerability scanning

## 📋 Prerequisites

- Python 3.9 or higher
- pip (Python package manager)
- Git

## 🛠️ Installation

1. Clone the repository:
```bash
git clone https://github.com/RockNRoll-cmd/2026_Projects.git
cd 2026_Projects
```

2. Create a virtual environment:
```bash
python -m venv .venv
source .venv/bin/activate  # On Windows: .venv\Scripts\activate
```

3. Install dependencies:
```bash
pip install -r requirements.txt
```

4. Install development tools:
```bash
pip install -e ".[dev]"
```

## 🧪 Testing

Run the test suite:
```bash
pytest
```

Run tests with coverage:
```bash
pytest --cov=src --cov-report=html
```

Run tests in parallel:
```bash
pytest -n auto
```

## 🔍 Code Quality Checks

### Linting

```bash
# Flake8 - Style guide enforcement
flake8 src/

# Pylint - Code analysis
pylint src/

# MyPy - Type checking
mypy src/
```

### Code Formatting

```bash
# Black - Code formatter
black src/ tests/

# Check formatting without making changes
black --check src/ tests/

# isort - Import sorting
isort src/ tests/
```

### Complexity Analysis

```bash
# Radon - Cyclomatic complexity
radon cc src/ -a

# Maintainability index
radon mi src/

# Raw metrics
radon raw src/ -s
```

## 🔒 Security Scanning

### Static Security Analysis

```bash
# Bandit - Security issues in code
bandit -r src/

# Generate JSON report
bandit -r src/ -f json -o bandit-report.json
```

### Dependency Vulnerability Scanning

```bash
# pip-audit - Scan installed packages
pip-audit

# Safety - Check for known vulnerabilities
safety check
```

## 📊 CI/CD Workflows

This project includes three GitHub Actions workflows:

### 1. CI - Validation and Verification (`.github/workflows/ci.yml`)
Runs on every push and pull request:
- Code linting (Black, isort, Flake8, Pylint, MyPy)
- Unit tests with coverage
- Security scanning (Bandit, Safety, pip-audit)
- Build validation

### 2. Code Quality (`.github/workflows/code-quality.yml`)
Runs on pull requests:
- Code complexity analysis (Radon)
- Dead code detection (Vulture)
- Maintainability metrics

### 3. Dependency Scan (`.github/workflows/dependency-scan.yml`)
Runs weekly and on dependency file changes:
- Automated dependency vulnerability scanning
- Security advisory checks
- Generates dependency reports

## 📁 Project Structure

```
.
├── .github/
│   └── workflows/          # CI/CD workflow definitions
│       ├── ci.yml
│       ├── code-quality.yml
│       └── dependency-scan.yml
├── src/                    # Source code
│   ├── __init__.py
│   ├── calculator.py       # Sample calculator module
│   └── validation.py       # Validation utilities
├── tests/                  # Test suite
│   ├── __init__.py
│   ├── test_calculator.py
│   └── test_validation.py
├── .bandit                 # Bandit configuration
├── .flake8                 # Flake8 configuration
├── pyproject.toml          # Project configuration and tool settings
├── requirements.txt        # Project dependencies
└── README.md              # This file
```

## 🔧 Configuration Files

- **pyproject.toml**: Central configuration for project metadata, build system, and tools (pytest, black, isort, mypy, pylint, coverage)
- **.flake8**: Flake8 linter configuration
- **.bandit**: Bandit security scanner configuration
- **requirements.txt**: Project dependencies

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Run the test suite and ensure all checks pass
5. Commit your changes (`git commit -m 'Add amazing feature'`)
6. Push to the branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

### Pre-commit Checks

Before committing, ensure:
- All tests pass: `pytest`
- Code is formatted: `black src/ tests/`
- Imports are sorted: `isort src/ tests/`
- No linting errors: `flake8 src/`
- No security issues: `bandit -r src/`

## 📝 Sample Code

The project includes two sample modules to demonstrate the validation tools:

1. **calculator.py**: A simple calculator class with type hints and comprehensive documentation
2. **validation.py**: Input validation utilities including email, phone, password validation, and input sanitization

## 📈 Code Coverage

This project aims for high test coverage. View coverage reports:
```bash
pytest --cov=src --cov-report=html
open htmlcov/index.html  # On macOS/Linux
```

## 🔐 Security Best Practices

This project follows security best practices:
- No hardcoded secrets or credentials
- Input validation and sanitization
- Regular dependency vulnerability scanning
- Automated security scanning in CI/CD
- Type hints for better code safety

## 📚 Additional Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Python Testing with pytest](https://docs.pytest.org/)
- [Black Code Formatter](https://black.readthedocs.io/)
- [Flake8 Documentation](https://flake8.pycqa.org/)
- [Bandit Security Tool](https://bandit.readthedocs.io/)

## 📄 License

This project is open source and available for educational purposes.

## 👥 Authors

- DevOps Team @ 2026_Projects

## 🎯 Future Enhancements

- [ ] Add integration tests
- [ ] Implement Docker containerization
- [ ] Add performance testing
- [ ] Set up SonarQube integration
- [ ] Add automated deployment workflows
- [ ] Implement semantic versioning automation
