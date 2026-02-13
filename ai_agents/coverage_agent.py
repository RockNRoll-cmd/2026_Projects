"""AI Agent for Coverage Analysis"""

from typing import Dict, Any, List, Set
from .base_agent import BaseAgent


class CoverageAgent(BaseAgent):
    """
    AI agent specialized for coverage analysis and improvement.
    Tracks coverage metrics and suggests targeted test generation.
    """
    
    def __init__(self, name: str = "CoverageAgent", config: Dict[str, Any] = None):
        """Initialize the coverage agent."""
        super().__init__(name, config)
        self.coverage_data = {}
        self.uncovered_items = set()
        
    def analyze(self, data: Dict[str, Any]) -> Dict[str, Any]:
        """
        Analyze coverage data.
        
        Args:
            data: Coverage metrics and reports
            
        Returns:
            Analysis with coverage gaps and recommendations
        """
        self.state = "analyzing"
        
        line_coverage = data.get("line_coverage", 0.0)
        branch_coverage = data.get("branch_coverage", 0.0)
        functional_coverage = data.get("functional_coverage", 0.0)
        uncovered = data.get("uncovered_items", [])
        
        self.uncovered_items = set(uncovered)
        
        analysis = {
            "line_coverage": line_coverage,
            "branch_coverage": branch_coverage,
            "functional_coverage": functional_coverage,
            "overall_coverage": (line_coverage + branch_coverage + functional_coverage) / 3.0,
            "gaps": self._identify_coverage_gaps(data),
            "priorities": self._prioritize_coverage(uncovered)
        }
        
        self.state = "idle"
        return analysis
        
    def decide(self, analysis: Dict[str, Any]) -> str:
        """
        Decide on coverage improvement actions.
        
        Args:
            analysis: Results from analyze()
            
        Returns:
            Action string
        """
        overall = analysis.get("overall_coverage", 0.0)
        
        if overall >= 90.0:
            return "excellent_coverage"
        elif overall >= 80.0:
            return "good_coverage_minor_improvement"
        elif overall >= 60.0:
            return "moderate_coverage_needs_work"
        else:
            return "poor_coverage_major_work"
            
    def _identify_coverage_gaps(self, data: Dict[str, Any]) -> List[str]:
        """Identify specific coverage gaps."""
        gaps = []
        
        if data.get("line_coverage", 0) < 80:
            gaps.append("line_coverage_gap")
            
        if data.get("branch_coverage", 0) < 80:
            gaps.append("branch_coverage_gap")
            
        if data.get("functional_coverage", 0) < 80:
            gaps.append("functional_coverage_gap")
            
        return gaps
        
    def _prioritize_coverage(self, uncovered: List[str]) -> List[str]:
        """Prioritize uncovered items for test generation."""
        # Simple priority: shorter items first (likely simpler to cover)
        return sorted(uncovered, key=len)[:10]
        
    def suggest_tests(self, analysis: Dict[str, Any]) -> List[str]:
        """
        Suggest new tests based on coverage gaps.
        
        Args:
            analysis: Coverage analysis results
            
        Returns:
            List of suggested test scenarios
        """
        suggestions = []
        priorities = analysis.get("priorities", [])
        
        for item in priorities:
            suggestions.append(f"Generate test for: {item}")
            
        return suggestions
