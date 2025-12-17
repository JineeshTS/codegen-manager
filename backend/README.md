# CodeGen Manager - Backend API

FastAPI backend for the CodeGen Manager AI-powered code generation system.

## Tech Stack

- **Framework:** FastAPI
- **Database:** PostgreSQL with SQLAlchemy 2.0 (async)
- **Authentication:** JWT tokens with bcrypt password hashing
- **Migrations:** Alembic
- **Python:** 3.11+

## Project Structure

```
backend/
├── app/
│   ├── core/           # Core utilities (database, security, config)
│   ├── models/         # SQLAlchemy models
│   ├── schemas/        # Pydantic schemas
│   ├── repositories/   # Data access layer
│   ├── services/       # Business logic
│   ├── api/            # API endpoints
│   └── main.py         # FastAPI app entry point
├── alembic/            # Database migrations
├── requirements.txt    # Python dependencies
└── .env.example        # Environment variables template
```

## Setup

### 1. Prerequisites

- Python 3.11+
- PostgreSQL 14+
- pip or poetry

### 2. Install Dependencies

```bash
cd backend
python -m venv venv
source venv/bin/activate  # On Windows: .\venv\Scripts\activate
pip install -r requirements.txt
```

### 3. Configure Environment

```bash
cp .env.example .env
# Edit .env and set your values:
# - DATABASE_URL
# - SECRET_KEY (generate a secure random key!)
# - Other settings as needed
```

### 4. Run Database Migrations

```bash
# Create database first (if it doesn't exist)
createdb codegen_manager

# Run migrations
alembic upgrade head
```

### 5. Run Development Server

```bash
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

The API will be available at:
- API: http://localhost:8000
- Interactive docs: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc

## API Endpoints

### Authentication

- `POST /api/v1/auth/register` - Register new user
- `POST /api/v1/auth/login` - Login and get tokens
- `POST /api/v1/auth/logout` - Logout (client-side token removal)
- `GET /api/v1/auth/me` - Get current user profile
- `PUT /api/v1/auth/me` - Update current user profile

### Health

- `GET /` - API information
- `GET /health` - Health check endpoint

## Development

### Run Tests

```bash
pytest
```

### Code Formatting

```bash
black app/
ruff check app/ --fix
```

### Create New Migration

```bash
alembic revision --autogenerate -m "description"
alembic upgrade head
```

### Rollback Migration

```bash
alembic downgrade -1
```

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `APP_NAME` | Application name | CodeGen Manager |
| `DEBUG` | Enable debug mode | false |
| `ENVIRONMENT` | Environment (dev/staging/prod) | production |
| `DATABASE_URL` | PostgreSQL connection string | See .env.example |
| `SECRET_KEY` | JWT secret key (min 32 chars) | (required) |
| `ALGORITHM` | JWT algorithm | HS256 |
| `ACCESS_TOKEN_EXPIRE_MINUTES` | Access token expiration | 30 |
| `REFRESH_TOKEN_EXPIRE_DAYS` | Refresh token expiration | 7 |
| `CORS_ORIGINS` | Allowed CORS origins (JSON array) | See .env.example |

## Security

- Passwords are hashed using bcrypt
- JWT tokens for authentication
- CORS configured for specific origins
- SQL injection protection via SQLAlchemy ORM
- Input validation with Pydantic

## Deployment

### Using Docker (recommended)

```bash
docker build -t codegen-manager-api .
docker run -p 8000:8000 --env-file .env codegen-manager-api
```

### Using systemd

Create a systemd service file for production deployment.

### Using PM2

```bash
pm2 start "uvicorn app.main:app --host 0.0.0.0 --port 8000" --name codegen-api
```

## Contributing

See main project README for contribution guidelines.

## License

MIT License - see LICENSE file for details.
