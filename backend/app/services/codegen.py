"""Code generation service using AI."""

import re
from typing import Dict, Any, Optional
from anthropic import Anthropic
from app.core.config import settings


class CodeGenService:
    """Service for AI-powered code generation."""

    def __init__(self, api_key: Optional[str] = None):
        self.api_key = api_key or settings.SECRET_KEY  # Use proper ANTHROPIC_API_KEY in production
        # self.client = Anthropic(api_key=self.api_key)  # Uncomment when API key is available

    def process_variables(self, template: str, variables: Dict[str, Any]) -> str:
        """Replace {{variable}} placeholders in template."""
        result = template
        for key, value in variables.items():
            pattern = r'\{\{' + re.escape(key) + r'\}\}'
            result = re.sub(pattern, str(value), result)
        return result

    def validate_template(self, template: str) -> bool:
        """Validate template syntax."""
        # Check for unclosed brackets
        open_count = template.count('{{')
        close_count = template.count('}}')
        return open_count == close_count

    async def generate_code(
        self,
        template_content: str,
        variables: Dict[str, Any],
        use_ai: bool = False
    ) -> str:
        """Generate code from template and variables.

        Args:
            template_content: Template with {{variable}} placeholders
            variables: Dictionary of variable names and values
            use_ai: Whether to use AI enhancement (requires API key)

        Returns:
            Generated code string
        """
        if not self.validate_template(template_content):
            raise ValueError("Invalid template: mismatched brackets")

        # Basic variable substitution
        code = self.process_variables(template_content, variables)

        # AI enhancement (placeholder for future implementation)
        if use_ai:
            # TODO: Integrate with Anthropic Claude API
            # code = await self._enhance_with_ai(code)
            pass

        return code

    async def _enhance_with_ai(self, code: str) -> str:
        """Enhance code using Claude API (placeholder)."""
        # Uncomment when API key is configured
        # response = await self.client.messages.create(
        #     model="claude-3-5-sonnet-20241022",
        #     max_tokens=4096,
        #     messages=[{
        #         "role": "user",
        #         "content": f"Enhance and optimize this code:\n\n{code}"
        #     }]
        # )
        # return response.content[0].text
        return code
