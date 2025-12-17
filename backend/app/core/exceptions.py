"""Custom exception classes and FastAPI exception handlers.

This module provides application-specific exceptions and handlers for
consistent error responses across the API.
"""

from typing import Any, Dict, Optional
from fastapi import Request, status
from fastapi.responses import JSONResponse


class AppException(Exception):
    """Base exception class for application errors.

    All custom exceptions should inherit from this class.

    Attributes:
        status_code: HTTP status code for the error response
        detail: Human-readable error message
    """

    def __init__(self, status_code: int, detail: str):
        """Initialize the exception.

        Args:
            status_code: HTTP status code
            detail: Error message
        """
        self.status_code = status_code
        self.detail = detail
        super().__init__(detail)


class NotFoundException(AppException):
    """Exception raised when a requested resource is not found.

    Returns HTTP 404 Not Found.

    Example:
        >>> raise NotFoundException("User not found")
    """

    def __init__(self, message: str):
        """Initialize the exception.

        Args:
            message: Description of what was not found
        """
        super().__init__(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=message
        )


class UnauthorizedException(AppException):
    """Exception raised when authentication fails or is missing.

    Returns HTTP 401 Unauthorized.

    Example:
        >>> raise UnauthorizedException("Invalid credentials")
    """

    def __init__(self, message: str = "Unauthorized"):
        """Initialize the exception.

        Args:
            message: Description of the authorization failure
        """
        super().__init__(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=message
        )


class ValidationException(AppException):
    """Exception raised when input validation fails.

    Returns HTTP 422 Unprocessable Entity.

    Attributes:
        errors: Dictionary of field-specific validation errors

    Example:
        >>> raise ValidationException(
        ...     "Validation failed",
        ...     errors={"email": "Invalid email format"}
        ... )
    """

    def __init__(self, message: str, errors: Optional[Dict[str, str]] = None):
        """Initialize the exception.

        Args:
            message: General validation error message
            errors: Dictionary mapping field names to error messages
        """
        super().__init__(
            status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
            detail=message
        )
        self.errors = errors or {}


async def app_exception_handler(request: Request, exc: AppException) -> JSONResponse:
    """Handle custom application exceptions.

    Args:
        request: The FastAPI request object
        exc: The application exception that was raised

    Returns:
        JSON response with error details
    """
    response_content: Dict[str, Any] = {
        "success": False,
        "message": exc.detail,
        "data": None,
    }

    # Add validation errors if present
    if isinstance(exc, ValidationException) and exc.errors:
        response_content["errors"] = exc.errors

    return JSONResponse(
        status_code=exc.status_code,
        content=response_content,
    )


async def generic_exception_handler(request: Request, exc: Exception) -> JSONResponse:
    """Handle unexpected exceptions.

    Args:
        request: The FastAPI request object
        exc: The exception that was raised

    Returns:
        JSON response with generic error message
    """
    return JSONResponse(
        status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
        content={
            "success": False,
            "message": "Internal server error",
            "data": None,
        },
    )


# Exception handlers dictionary for use in FastAPI app setup
# Usage: for exc_class, handler in handlers.items():
#            app.add_exception_handler(exc_class, handler)
handlers = {
    AppException: app_exception_handler,
    Exception: generic_exception_handler,
}
