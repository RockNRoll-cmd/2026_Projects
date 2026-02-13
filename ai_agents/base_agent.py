"""Base AI Agent for Verification Tasks"""

from abc import ABC, abstractmethod
from typing import Dict, Any, List


class BaseAgent(ABC):
    """
    Abstract base class for AI verification agents.
    Provides common interface for all AI agents in the verification environment.
    """
    
    def __init__(self, name: str, config: Dict[str, Any] = None):
        """
        Initialize the base agent.
        
        Args:
            name: Agent identifier
            config: Configuration dictionary for the agent
        """
        self.name = name
        self.config = config or {}
        self.state = "idle"
        self.observations = []
        
    @abstractmethod
    def analyze(self, data: Dict[str, Any]) -> Dict[str, Any]:
        """
        Analyze input data and return insights.
        
        Args:
            data: Input data to analyze
            
        Returns:
            Dictionary containing analysis results
        """
        pass
    
    @abstractmethod
    def decide(self, analysis: Dict[str, Any]) -> str:
        """
        Make a decision based on analysis.
        
        Args:
            analysis: Analysis results from analyze()
            
        Returns:
            Decision string
        """
        pass
    
    def observe(self, observation: Any) -> None:
        """
        Record an observation.
        
        Args:
            observation: Data to observe
        """
        self.observations.append(observation)
        
    def reset(self) -> None:
        """Reset agent state."""
        self.state = "idle"
        self.observations = []
        
    def get_status(self) -> Dict[str, Any]:
        """
        Get current agent status.
        
        Returns:
            Dictionary containing agent status
        """
        return {
            "name": self.name,
            "state": self.state,
            "observations_count": len(self.observations)
        }
