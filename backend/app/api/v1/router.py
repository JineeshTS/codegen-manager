"""Main API router for version 1.

This module combines all API endpoints under the /api/v1 prefix.
"""

from fastapi import APIRouter

from app.api.v1.endpoints import auth, templates, projects


# Create main API router with v1 prefix
api_router = APIRouter(prefix="/api/v1")

# Include all endpoint routers
api_router.include_router(auth.router)
api_router.include_router(templates.router)
api_router.include_router(projects.router)
