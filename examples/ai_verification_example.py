"""
Example: AI-Driven Verification Flow
Demonstrates integration of AI Agents with C++ models and UVM/SV verification
"""

import sys
sys.path.append('..')

from ai_agents import VerificationAgent, CoverageAgent, DebugAgent


def main():
    """Main verification flow with AI agents."""
    
    print("=" * 60)
    print("AI-Driven Verification Example")
    print("=" * 60)
    
    # Initialize AI agents
    verif_agent = VerificationAgent("MainVerifier")
    coverage_agent = CoverageAgent("CoverageAnalyzer")
    debug_agent = DebugAgent("DebugAnalyzer")
    
    print("\n1. Running verification with AI analysis...")
    
    # Simulate test results
    test_data = {
        "test_status": "fail",
        "failures": [
            "Assertion failure at addr 0x1000",
            "Protocol violation: invalid handshake",
            "Timeout waiting for response"
        ],
        "coverage": 75.5
    }
    
    # Analyze results
    analysis = verif_agent.analyze(test_data)
    decision = verif_agent.decide(analysis)
    
    print(f"\nTest Status: {analysis['test_status']}")
    print(f"Failures: {analysis['failure_count']}")
    print(f"Coverage: {analysis['coverage_percentage']}%")
    print(f"Decision: {decision}")
    print("\nPatterns identified:")
    for pattern in analysis['patterns']:
        print(f"  - {pattern}")
    print("\nRecommendations:")
    for rec in analysis['recommendations']:
        print(f"  - {rec}")
    
    # Coverage analysis
    print("\n" + "=" * 60)
    print("2. Coverage Analysis")
    print("=" * 60)
    
    coverage_data = {
        "line_coverage": 78.0,
        "branch_coverage": 72.5,
        "functional_coverage": 76.0,
        "uncovered_items": [
            "reset_handler",
            "error_path_1",
            "boundary_case_max",
            "overflow_condition"
        ]
    }
    
    cov_analysis = coverage_agent.analyze(coverage_data)
    cov_decision = coverage_agent.decide(cov_analysis)
    
    print(f"\nLine Coverage: {cov_analysis['line_coverage']}%")
    print(f"Branch Coverage: {cov_analysis['branch_coverage']}%")
    print(f"Functional Coverage: {cov_analysis['functional_coverage']}%")
    print(f"Overall Coverage: {cov_analysis['overall_coverage']:.2f}%")
    print(f"Decision: {cov_decision}")
    
    print("\nCoverage Gaps:")
    for gap in cov_analysis['gaps']:
        print(f"  - {gap}")
    
    print("\nPriority items to cover:")
    for item in cov_analysis['priorities'][:5]:
        print(f"  - {item}")
    
    # Test suggestions
    suggestions = coverage_agent.suggest_tests(cov_analysis)
    print("\nSuggested tests:")
    for suggestion in suggestions[:3]:
        print(f"  - {suggestion}")
    
    # Debug analysis
    print("\n" + "=" * 60)
    print("3. Debug Analysis")
    print("=" * 60)
    
    failure_data = {
        "error_message": "Assertion failure: expected 0x100, got 0x200",
        "traceback": [
            "processor_model.cpp:145",
            "execute_instruction()",
            "step()"
        ],
        "context": {
            "pc": "0x1000",
            "register_state": "R1=0x200",
            "cycle": 1024
        }
    }
    
    debug_analysis = debug_agent.analyze(failure_data)
    debug_decision = debug_agent.decide(debug_analysis)
    
    print(f"\nError Type: {debug_analysis['error_type']}")
    print(f"Severity: {debug_analysis['severity']}")
    print(f"Decision: {debug_decision}")
    
    print("\nLikely Root Causes:")
    for cause in debug_analysis['likely_causes']:
        print(f"  - {cause}")
    
    print("\nDebug Steps:")
    for step in debug_analysis['debug_steps']:
        print(f"  - {step}")
    
    # Summary
    print("\n" + "=" * 60)
    print("4. Verification Summary")
    print("=" * 60)
    
    print(f"\nVerification Agent Status: {verif_agent.get_status()}")
    print(f"Coverage Agent Status: {coverage_agent.get_status()}")
    print(f"Debug Agent Status: {debug_agent.get_status()}")
    
    print("\n✓ AI-driven verification analysis complete")
    print("=" * 60)


if __name__ == "__main__":
    main()
