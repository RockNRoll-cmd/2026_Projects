"""AI Agent for Debug Analysis"""

from typing import Dict, Any, List
from .base_agent import BaseAgent


class DebugAgent(BaseAgent):
    """
    AI agent for debugging and root cause analysis.
    Analyzes failures and suggests debugging strategies.
    """
    
    def __init__(self, name: str = "DebugAgent", config: Dict[str, Any] = None):
        """Initialize the debug agent."""
        super().__init__(name, config)
        self.failure_history = []
        self.root_causes = {}
        
    def analyze(self, data: Dict[str, Any]) -> Dict[str, Any]:
        """
        Analyze failure data for debugging.
        
        Args:
            data: Failure logs and diagnostic information
            
        Returns:
            Debug analysis with likely root causes
        """
        self.state = "debugging"
        
        error_msg = data.get("error_message", "")
        traceback = data.get("traceback", [])
        context = data.get("context", {})
        
        analysis = {
            "error_type": self._classify_error(error_msg),
            "likely_causes": self._identify_causes(error_msg, traceback),
            "debug_steps": self._suggest_debug_steps(error_msg, traceback),
            "severity": self._assess_severity(error_msg, context)
        }
        
        self.failure_history.append(analysis)
        self.state = "idle"
        return analysis
        
    def decide(self, analysis: Dict[str, Any]) -> str:
        """
        Decide on debugging action.
        
        Args:
            analysis: Results from analyze()
            
        Returns:
            Debug action string
        """
        severity = analysis.get("severity", "unknown")
        
        if severity == "critical":
            return "immediate_attention_required"
        elif severity == "high":
            return "priority_debug_needed"
        elif severity == "medium":
            return "standard_debug"
        else:
            return "low_priority_debug"
            
    def _classify_error(self, error_msg: str) -> str:
        """Classify the type of error."""
        error_lower = error_msg.lower()
        
        if "timeout" in error_lower:
            return "timeout_error"
        elif "assertion" in error_lower or "assert" in error_lower:
            return "assertion_failure"
        elif "null" in error_lower or "nullptr" in error_lower:
            return "null_pointer_error"
        elif "protocol" in error_lower:
            return "protocol_error"
        elif "memory" in error_lower:
            return "memory_error"
        else:
            return "unknown_error"
            
    def _identify_causes(self, error_msg: str, traceback: List[str]) -> List[str]:
        """Identify likely root causes."""
        causes = []
        error_type = self._classify_error(error_msg)
        
        cause_map = {
            "timeout_error": [
                "Clock not toggling",
                "Infinite loop in DUT",
                "Missing response signal"
            ],
            "assertion_failure": [
                "Incorrect expected value",
                "Timing issue",
                "State machine error"
            ],
            "null_pointer_error": [
                "Uninitialized pointer",
                "Deleted object access",
                "Invalid reference"
            ],
            "protocol_error": [
                "Handshake violation",
                "Invalid sequence",
                "Timing constraint violation"
            ]
        }
        
        return cause_map.get(error_type, ["Unknown cause - manual investigation needed"])
        
    def _suggest_debug_steps(self, error_msg: str, traceback: List[str]) -> List[str]:
        """Suggest debugging steps."""
        steps = [
            "Review error message and context",
            "Check signal waveforms around failure time",
            "Verify input stimulus correctness"
        ]
        
        error_type = self._classify_error(error_msg)
        
        if error_type == "timeout_error":
            steps.append("Verify clock generation and gating")
            steps.append("Check for deadlock conditions")
        elif error_type == "assertion_failure":
            steps.append("Review assertion definition")
            steps.append("Check timing relationships")
        elif error_type == "protocol_error":
            steps.append("Verify protocol compliance")
            steps.append("Check handshake signals")
            
        return steps
        
    def _assess_severity(self, error_msg: str, context: Dict[str, Any]) -> str:
        """Assess error severity."""
        error_type = self._classify_error(error_msg)
        
        # Critical errors
        if error_type in ["memory_error", "protocol_error"]:
            return "critical"
        
        # High priority
        if error_type in ["null_pointer_error", "assertion_failure"]:
            return "high"
        
        # Medium priority
        if error_type == "timeout_error":
            return "medium"
        
        return "low"
