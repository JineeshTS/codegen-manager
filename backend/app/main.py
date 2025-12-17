"""FastAPI application factory and entry point.

This module creates and configures the FastAPI application instance
with middleware, exception handlers, and API routers.
"""

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse

from app.core.config import settings
from app.core.exceptions import handlers
from app.api.v1.router import api_router


def create_app() -> FastAPI:
    """Create and configure the FastAPI application.

    Returns:
        Configured FastAPI application instance
    """
    app = FastAPI(
        title=settings.APP_NAME,
        description="AI-Powered Code Generation Management System",
        version="1.0.0",
        docs_url="/docs",
        redoc_url="/redoc",
        debug=settings.DEBUG,
    )

    # Configure CORS
    app.add_middleware(
        CORSMiddleware,
        allow_origins=settings.CORS_ORIGINS,
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

    # Add exception handlers
    for exc_class, handler in handlers.items():
        app.add_exception_handler(exc_class, handler)

    # Include API routers
    app.include_router(api_router)

    # Root endpoint
    @app.get("/", tags=["Root"])
    async def root():
        """Root endpoint returning API information."""
        return {
            "success": True,
            "message": "CodeGen Manager API",
            "data": {
                "version": "1.0.0",
                "docs": "/docs",
                "api": "/api/v1"
            }
        }

    # Health check endpoint
    @app.get("/health", tags=["Health"])
    async def health_check():
        """Health check endpoint for monitoring."""
        return {
            "success": True,
            "message": "Service is healthy",
            "data": {
                "status": "ok",
                "environment": settings.ENVIRONMENT
            }
        }

    return app


# Create application instance
app = create_app()


# Startup event
@app.on_event("startup")
async def startup_event():
    """Execute on application startup."""
    print(f"Starting {settings.APP_NAME} in {settings.ENVIRONMENT} mode")


# Shutdown event
@app.on_event("shutdown")
async def shutdown_event():
    """Execute on application shutdown."""
    print(f"Shutting down {settings.APP_NAME}")
