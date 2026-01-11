# PGAGI - DevOps Assignment

This project demonstrates a full-stack application with a FastAPI backend and a Next.js frontend, deployed to both AWS and GCP using Terraform and GitHub Actions.

## Project Structure

```
.
├── backend/               # FastAPI backend application
├── frontend/              # Next.js frontend application
├── infra/                 # Infrastructure as Code (Terraform)
│   ├── aws/               # AWS Infrastructure (ECS, ALB, VPC)
│   └── gcp/               # GCP Infrastructure (Cloud Run, IAM)
├── .github/workflows/     # CI/CD Pipelines
└── docker-compose.yaml    # Local development with Docker
```

## Prerequisites

- Python 3.8+
- Node.js 16+
- Docker & Docker Compose
- Terraform 1.10.0+ (for deployment)
- AWS CLI & Google Cloud SDK (for deployment)

## Local Development

### Option 1: Docker Compose (Recommended)

Run the entire stack locally with a single command:

```bash
docker-compose up --build
```

- Frontend: `http://localhost:3000`
- Backend: `http://localhost:8000`

### Option 2: Manual Setup

#### Backend

1. Navigate to `backend`:
   ```bash
   cd backend
   python -m venv venv
   source venv/bin/activate  # Windows: .\venv\Scripts\activate
   pip install -r requirements.txt
   uvicorn app.main:app --reload --port 8000
   ```

#### Frontend

1. Navigate to `frontend`:
   ```bash
   cd frontend
   npm install
   npm run dev
   ```
2. The frontend will connect to `http://localhost:8000` by default. To change this, update `NEXT_PUBLIC_API_URL` in `.env.local`.

## Infrastructure

The project uses Terraform to provision infrastructure on two clouds:

### AWS
- **Services:** ECS Fargate, Application Load Balancer (ALB), ECR.
- **Location:** `infra/aws`
- **Resources:** VPC, Subnets, Security Groups, IAM Roles, ECS Cluster/Service/Task Definition.

### GCP
- **Services:** Cloud Run, Artifact Registry.
- **Location:** `infra/gcp`
- **Resources:** Cloud Run Services (Frontend & Backend), IAM bindings.

## CI/CD Pipeline

The GitHub Actions workflow (`.github/workflows/deploy.yaml`) handles the deployment process:

1. **Infra Provisioning:** Runs Terraform to provision infrastructure with dummy images first to establish networking (ALB DNS, Cloud Run URLs).
2. **Build & Push:** Builds Docker images for Frontend and Backend.
   - Frontend is built with `NEXT_PUBLIC_API_URL` pointing to the provisioned Load Balancer/Service URL.
   - Images are pushed to AWS ECR and GCP Artifact Registry.
3. **Deploy:** Updates the Terraform state with the new image tags to deploy the actual application.

## API Endpoints

- `GET /api/health`: Health check (`{"status": "healthy"}`)
- `GET /api/message`: Integration check (`{"message": "You've successfully integrated the backend!"}`)
