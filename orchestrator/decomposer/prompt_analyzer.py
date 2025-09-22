"""
Prompt Decomposition and Analysis System

Breaks down complex prompts into atomic tasks that can be handled
by specialized agents.
"""

from typing import List, Dict, Any, Optional
from dataclasses import dataclass
from enum import Enum


class TaskType(Enum):
    """Types of development tasks"""
    WEB_DEVELOPMENT = "web_development"
    API_DEVELOPMENT = "api_development"
    DATA_ANALYSIS = "data_analysis"
    AUTOMATION_SCRIPT = "automation_script"
    CLOUD_INFRASTRUCTURE = "cloud_infrastructure"
    DATABASE_DESIGN = "database_design"
    TESTING = "testing"
    DOCUMENTATION = "documentation"
    CODE_REVIEW = "code_review"
    DEBUGGING = "debugging"
    OPTIMIZATION = "optimization"
    SECURITY_AUDIT = "security_audit"


class Complexity(Enum):
    """Task complexity levels"""
    SIMPLE = "simple"       # Single file, straightforward logic
    MODERATE = "moderate"   # Multiple files, some integration
    COMPLEX = "complex"     # System-wide, architectural decisions
    EXPERT = "expert"       # Requires deep expertise, critical systems


@dataclass
class SubTask:
    """Represents a decomposed subtask"""
    id: str
    description: str
    task_type: TaskType
    complexity: Complexity
    dependencies: List[str]  # IDs of tasks that must complete first
    required_capabilities: List[str]  # What the agent needs to do
    estimated_tokens: int
    preferred_models: List[str]  # Ranked list of suitable models
    context_needed: Dict[str, Any]  # Files, APIs, docs needed
    success_criteria: List[str]  # How to validate completion


class PromptAnalyzer:
    """Analyzes and decomposes prompts into manageable subtasks"""
    
    def __init__(self):
        self.task_patterns = self._initialize_patterns()
        self.complexity_indicators = self._initialize_complexity_indicators()
    
    def _initialize_patterns(self) -> Dict[TaskType, List[str]]:
        """Initialize task type detection patterns"""
        return {
            TaskType.WEB_DEVELOPMENT: [
                "website", "web app", "frontend", "react", "vue", "angular",
                "html", "css", "javascript", "ui", "ux", "responsive"
            ],
            TaskType.API_DEVELOPMENT: [
                "api", "rest", "graphql", "endpoint", "backend", "server",
                "microservice", "webhook", "integration"
            ],
            TaskType.DATA_ANALYSIS: [
                "analyze", "data", "statistics", "visualization", "report",
                "pandas", "numpy", "matplotlib", "insights", "metrics"
            ],
            TaskType.AUTOMATION_SCRIPT: [
                "automate", "script", "batch", "workflow", "pipeline",
                "cron", "scheduled", "task automation"
            ],
            TaskType.CLOUD_INFRASTRUCTURE: [
                "aws", "azure", "gcp", "cloud", "infrastructure", "terraform",
                "kubernetes", "docker", "deployment", "ci/cd"
            ],
            TaskType.DATABASE_DESIGN: [
                "database", "sql", "mongodb", "schema", "migration",
                "query", "index", "optimization"
            ],
            TaskType.TESTING: [
                "test", "unit test", "integration test", "e2e", "coverage",
                "pytest", "jest", "testing", "qa"
            ],
            TaskType.DOCUMENTATION: [
                "document", "readme", "docs", "api documentation",
                "comments", "docstring", "guide", "tutorial"
            ],
            TaskType.CODE_REVIEW: [
                "review", "refactor", "improve", "clean", "optimize code",
                "best practices", "code quality"
            ],
            TaskType.DEBUGGING: [
                "debug", "fix", "error", "bug", "issue", "problem",
                "troubleshoot", "diagnose"
            ],
            TaskType.OPTIMIZATION: [
                "optimize", "performance", "speed up", "efficient",
                "reduce", "improve performance", "bottleneck"
            ],
            TaskType.SECURITY_AUDIT: [
                "security", "vulnerability", "audit", "penetration",
                "secure", "encryption", "authentication", "authorization"
            ]
        }
    
    def _initialize_complexity_indicators(self) -> Dict[Complexity, List[str]]:
        """Initialize complexity detection patterns"""
        return {
            Complexity.SIMPLE: [
                "simple", "basic", "single", "small", "quick", "minor"
            ],
            Complexity.MODERATE: [
                "moderate", "standard", "typical", "regular", "common"
            ],
            Complexity.COMPLEX: [
                "complex", "advanced", "large", "system", "architecture",
                "integrate", "full-stack", "enterprise"
            ],
            Complexity.EXPERT: [
                "expert", "critical", "high-performance", "secure",
                "scalable", "production", "mission-critical"
            ]
        }
    
    def analyze_prompt(self, prompt: str) -> Dict[str, Any]:
        """
        Analyze a prompt to understand its requirements
        
        Returns:
            Dictionary containing:
            - detected_tasks: List of TaskType
            - complexity: Overall Complexity
            - key_requirements: List of specific requirements
            - suggested_approach: High-level approach recommendation
        """
        prompt_lower = prompt.lower()
        
        # Detect task types
        detected_tasks = []
        for task_type, patterns in self.task_patterns.items():
            if any(pattern in prompt_lower for pattern in patterns):
                detected_tasks.append(task_type)
        
        # Detect complexity
        complexity = Complexity.MODERATE  # default
        for level, indicators in self.complexity_indicators.items():
            if any(indicator in prompt_lower for indicator in indicators):
                complexity = level
                break
        
        # Extract key requirements
        key_requirements = self._extract_requirements(prompt)
        
        # Suggest approach
        suggested_approach = self._suggest_approach(detected_tasks, complexity)
        
        return {
            "detected_tasks": detected_tasks,
            "complexity": complexity,
            "key_requirements": key_requirements,
            "suggested_approach": suggested_approach
        }
    
    def decompose_prompt(self, prompt: str) -> List[SubTask]:
        """
        Decompose a complex prompt into subtasks
        
        Args:
            prompt: The user's request
            
        Returns:
            List of SubTask objects that can be executed
        """
        analysis = self.analyze_prompt(prompt)
        subtasks = []
        
        # Create subtasks based on detected task types
        for i, task_type in enumerate(analysis["detected_tasks"]):
            subtask = SubTask(
                id=f"task_{i+1}",
                description=self._generate_task_description(task_type, prompt),
                task_type=task_type,
                complexity=analysis["complexity"],
                dependencies=self._identify_dependencies(i, task_type, analysis["detected_tasks"]),
                required_capabilities=self._get_required_capabilities(task_type),
                estimated_tokens=self._estimate_tokens(task_type, analysis["complexity"]),
                preferred_models=self._select_models(task_type, analysis["complexity"]),
                context_needed=self._gather_context(task_type),
                success_criteria=self._define_success_criteria(task_type)
            )
            subtasks.append(subtask)
        
        return subtasks
    
    def _extract_requirements(self, prompt: str) -> List[str]:
        """Extract specific requirements from prompt"""
        requirements = []
        
        # Look for specific technologies mentioned
        tech_keywords = ["python", "javascript", "react", "django", "fastapi", 
                        "postgresql", "mongodb", "aws", "docker", "kubernetes"]
        for tech in tech_keywords:
            if tech in prompt.lower():
                requirements.append(f"Uses {tech}")
        
        # Look for specific constraints
        if "fast" in prompt.lower() or "performance" in prompt.lower():
            requirements.append("Performance optimized")
        if "secure" in prompt.lower():
            requirements.append("Security focused")
        if "test" in prompt.lower():
            requirements.append("Include tests")
        
        return requirements
    
    def _suggest_approach(self, tasks: List[TaskType], complexity: Complexity) -> str:
        """Suggest an approach based on detected tasks and complexity"""
        if complexity in [Complexity.COMPLEX, Complexity.EXPERT]:
            return "Multi-agent parallel execution with specialized models"
        elif len(tasks) > 3:
            return "Sequential pipeline with task-specific agents"
        else:
            return "Single agent with capability switching"
    
    def _generate_task_description(self, task_type: TaskType, prompt: str) -> str:
        """Generate a specific description for a subtask"""
        descriptions = {
            TaskType.WEB_DEVELOPMENT: "Develop frontend components and UI",
            TaskType.API_DEVELOPMENT: "Build backend API endpoints",
            TaskType.DATA_ANALYSIS: "Analyze data and generate insights",
            TaskType.AUTOMATION_SCRIPT: "Create automation scripts",
            TaskType.CLOUD_INFRASTRUCTURE: "Configure cloud infrastructure",
            TaskType.DATABASE_DESIGN: "Design and implement database schema",
            TaskType.TESTING: "Write and execute tests",
            TaskType.DOCUMENTATION: "Generate documentation",
            TaskType.CODE_REVIEW: "Review and improve code quality",
            TaskType.DEBUGGING: "Debug and fix issues",
            TaskType.OPTIMIZATION: "Optimize performance",
            TaskType.SECURITY_AUDIT: "Perform security audit"
        }
        return descriptions.get(task_type, "Execute task")
    
    def _identify_dependencies(self, index: int, task_type: TaskType, 
                               all_tasks: List[TaskType]) -> List[str]:
        """Identify task dependencies"""
        dependencies = []
        
        # Documentation and testing usually depend on implementation
        if task_type in [TaskType.DOCUMENTATION, TaskType.TESTING]:
            if index > 0:
                dependencies.append(f"task_{index}")
        
        # API development should come before frontend that consumes it
        if task_type == TaskType.WEB_DEVELOPMENT:
            for i, t in enumerate(all_tasks[:index]):
                if t == TaskType.API_DEVELOPMENT:
                    dependencies.append(f"task_{i+1}")
        
        return dependencies
    
    def _get_required_capabilities(self, task_type: TaskType) -> List[str]:
        """Get required capabilities for a task type"""
        capabilities = {
            TaskType.WEB_DEVELOPMENT: ["code_generation", "ui_design", "responsive_layout"],
            TaskType.API_DEVELOPMENT: ["code_generation", "api_design", "database_interaction"],
            TaskType.DATA_ANALYSIS: ["data_processing", "statistics", "visualization"],
            TaskType.AUTOMATION_SCRIPT: ["scripting", "system_interaction", "scheduling"],
            TaskType.CLOUD_INFRASTRUCTURE: ["infrastructure_as_code", "cloud_services", "networking"],
            TaskType.DATABASE_DESIGN: ["schema_design", "query_optimization", "migrations"],
            TaskType.TESTING: ["test_generation", "assertion_writing", "coverage_analysis"],
            TaskType.DOCUMENTATION: ["technical_writing", "api_documentation", "examples"],
            TaskType.CODE_REVIEW: ["code_analysis", "best_practices", "refactoring"],
            TaskType.DEBUGGING: ["error_analysis", "debugging_strategies", "root_cause_analysis"],
            TaskType.OPTIMIZATION: ["performance_analysis", "profiling", "optimization_techniques"],
            TaskType.SECURITY_AUDIT: ["vulnerability_scanning", "security_best_practices", "threat_modeling"]
        }
        return capabilities.get(task_type, ["general_coding"])
    
    def _estimate_tokens(self, task_type: TaskType, complexity: Complexity) -> int:
        """Estimate token usage for a task"""
        base_tokens = {
            TaskType.WEB_DEVELOPMENT: 3000,
            TaskType.API_DEVELOPMENT: 2500,
            TaskType.DATA_ANALYSIS: 2000,
            TaskType.AUTOMATION_SCRIPT: 1500,
            TaskType.CLOUD_INFRASTRUCTURE: 2000,
            TaskType.DATABASE_DESIGN: 1500,
            TaskType.TESTING: 2000,
            TaskType.DOCUMENTATION: 1000,
            TaskType.CODE_REVIEW: 1500,
            TaskType.DEBUGGING: 2000,
            TaskType.OPTIMIZATION: 2500,
            TaskType.SECURITY_AUDIT: 3000
        }
        
        complexity_multiplier = {
            Complexity.SIMPLE: 0.5,
            Complexity.MODERATE: 1.0,
            Complexity.COMPLEX: 2.0,
            Complexity.EXPERT: 3.0
        }
        
        base = base_tokens.get(task_type, 2000)
        multiplier = complexity_multiplier.get(complexity, 1.0)
        
        return int(base * multiplier)
    
    def _select_models(self, task_type: TaskType, complexity: Complexity) -> List[str]:
        """Select appropriate models for a task"""
        # Model selection based on task type and complexity
        model_preferences = {
            TaskType.WEB_DEVELOPMENT: ["gpt-4", "claude-opus", "gemini-pro"],
            TaskType.API_DEVELOPMENT: ["gpt-4", "claude-opus", "codellama:34b"],
            TaskType.DATA_ANALYSIS: ["gpt-4", "gemini-pro", "claude-opus"],
            TaskType.AUTOMATION_SCRIPT: ["gpt-4", "codellama:34b", "qwen2.5-coder:32b"],
            TaskType.CLOUD_INFRASTRUCTURE: ["gpt-4", "claude-opus", "gemini-pro"],
            TaskType.DATABASE_DESIGN: ["gpt-4", "claude-opus", "gemini-pro"],
            TaskType.TESTING: ["gpt-4", "claude-opus", "codellama:34b"],
            TaskType.DOCUMENTATION: ["gpt-4", "claude-opus", "gemini-flash"],
            TaskType.CODE_REVIEW: ["gpt-4", "claude-opus", "gemini-pro"],
            TaskType.DEBUGGING: ["gpt-4", "claude-opus", "grok-3"],
            TaskType.OPTIMIZATION: ["gpt-4", "claude-opus", "gemini-pro"],
            TaskType.SECURITY_AUDIT: ["gpt-4", "claude-opus", "grok-3"]
        }
        
        models = model_preferences.get(task_type, ["gpt-4", "claude-opus"])
        
        # For complex tasks, prefer more capable models
        if complexity in [Complexity.COMPLEX, Complexity.EXPERT]:
            # Move most capable models to front
            if "claude-opus" in models:
                models.remove("claude-opus")
                models.insert(0, "claude-opus")
            if "gpt-4" in models and "gpt-4" not in models[:2]:
                models.remove("gpt-4")
                models.insert(0, "gpt-4")
        
        return models
    
    def _gather_context(self, task_type: TaskType) -> Dict[str, Any]:
        """Gather necessary context for a task"""
        return {
            "required_files": [],
            "api_endpoints": [],
            "documentation_links": [],
            "existing_code": [],
            "constraints": []
        }
    
    def _define_success_criteria(self, task_type: TaskType) -> List[str]:
        """Define success criteria for a task"""
        criteria = {
            TaskType.WEB_DEVELOPMENT: [
                "Components render without errors",
                "Responsive on mobile and desktop",
                "Passes accessibility checks"
            ],
            TaskType.API_DEVELOPMENT: [
                "All endpoints respond correctly",
                "Proper error handling",
                "Input validation implemented"
            ],
            TaskType.DATA_ANALYSIS: [
                "Data correctly processed",
                "Insights clearly presented",
                "Visualizations generated"
            ],
            TaskType.AUTOMATION_SCRIPT: [
                "Script executes without errors",
                "Handles edge cases",
                "Proper logging implemented"
            ],
            TaskType.CLOUD_INFRASTRUCTURE: [
                "Infrastructure deploys successfully",
                "Security best practices followed",
                "Cost optimized"
            ],
            TaskType.DATABASE_DESIGN: [
                "Schema properly normalized",
                "Indexes optimized",
                "Migrations work correctly"
            ],
            TaskType.TESTING: [
                "Tests pass",
                "Good coverage achieved",
                "Edge cases covered"
            ],
            TaskType.DOCUMENTATION: [
                "Clear and complete",
                "Examples provided",
                "API documented"
            ],
            TaskType.CODE_REVIEW: [
                "Issues identified",
                "Improvements suggested",
                "Best practices verified"
            ],
            TaskType.DEBUGGING: [
                "Issue identified",
                "Fix implemented",
                "Tests added"
            ],
            TaskType.OPTIMIZATION: [
                "Performance improved",
                "Metrics documented",
                "No functionality broken"
            ],
            TaskType.SECURITY_AUDIT: [
                "Vulnerabilities identified",
                "Fixes recommended",
                "Security best practices verified"
            ]
        }
        return criteria.get(task_type, ["Task completed successfully"])