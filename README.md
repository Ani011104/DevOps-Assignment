# PG-AGI DevOps Assignment

This repository contains a full-stack application (FastAPI + Next.js) with a robust CI/CD pipeline and multi-cloud infrastructure (AWS & GCP) managed via Terraform.

## 📂 Folder Structure

```text
.
├── .github/workflows/       # CI/CD Pipeline Definitions
│   ├── intergration-ci.yaml # PR-based tests (Pytest & Playwright)
│   ├── ECR.yaml            # Build & Push images to AWS/GCP registries
│   └── deploy.yaml         # Multi-cloud infrastructure & app deployment
├── backend/                # FastAPI Application
│   ├── app/
│   │   └── main.py         # API Routes and Logic
│   ├── test/
│   │   └── test_routes.py  # Unit tests for backend
│   └── Dockerfile          # Backend containerization
├── frontend/               # Next.js Application
│   ├── pages/
│   │   └── index.js        # Main UI and Backend integration
│   ├── tests/              # E2E tests (Playwright)
│   └── Dockerfile          # Frontend containerization
├── infra/                  # Terraform Infrastructure as Code
│   ├── aws/                # AWS Resources (VPC, ECS, ALB)
│   └── gcp/                # GCP Resources (Cloud Run, IAM)
└── docker-compose.yaml     # Local development setup
```

---

## 🚀 Backend API (FastAPI)

The backend is built with FastAPI, providing a high-performance asynchronous API.

### Routes
| Method | Endpoint | Description |
| :--- | :--- | :--- |
| `GET` | `/health` | Returns the health status of the backend service. |
| `GET` | `/message` | Returns a confirmation message of successful integration. |

---

## 💻 Frontend (Next.js)

The frontend is a Next.js application that provides a modern UI and integrates with the backend API.

### Routes
| Path | Component | Description |
| :--- | :--- | :--- |
| `/` | `index.js` | The main landing page. It checks backend health and displays the integration message. |

---

## 🛠️ CI/CD Pipelines (GitHub Actions)

We use three primary workflows to ensure code quality and automated deployments.

### 1. Integration CI (`intergration-ci.yaml`)
*   **Trigger**: Pull Requests to the `develop` branch.
*   **Actions**:
    *   Runs Python unit tests using `pytest`.
    *   Executes End-to-End (E2E) tests using `Playwright`.
    *   Ensures the backend and frontend can communicate before merging.

### 2. Build & Push (`ECR.yaml`)
*   **Trigger**: Push to the `develop` branch.
*   **Actions**:
    *   Builds Docker images for both Backend and Frontend.
    *   Pushes images to **AWS Elastic Container Registry (ECR)**.
    *   Pushes images to **GCP Artifact Registry**.

### 3. Deploy (`deploy.yaml`)
*   **Trigger**: Push to the `main` branch.
*   **Actions**:
    *   **Bootstrap**: Initializes and applies Terraform for both AWS and GCP.
    *   **Build & Push**: Re-builds images with the latest commit tag.
    *   **Deploy**: Updates AWS ECS services and GCP Cloud Run services with the new images.

---

## ☁️ Infrastructure

### 🟠 AWS Infrastructure
The AWS setup is designed for high availability and scalability.

#### Components:
*   **VPC**: Custom VPC with public and private subnets across multiple Availability Zones.
*   **Networking**: Internet Gateway for public access and NAT Gateways for private subnet egress.
*   **ALB**: Application Load Balancer to distribute traffic to ECS tasks.
*   **ECS (Fargate)**: Serverless container orchestration for running backend and frontend services.
*   **Monitoring**: CloudWatch Alarms and SNS for real-time alerting.

### 🌐 Deployment Access
Once deployed, the application can be accessed via the following URLs:

#### AWS (Production)
The application is accessible through the **Application Load Balancer (ALB) DNS name**.
*   **Frontend**: `http://<ALB_DNS_NAME>`
*   **Backend**: `http://<ALB_DNS_NAME>/health` (or as configured in listener rules)

#### GCP (Production)
The application is accessible through the **Cloud Run Service URLs**.
*   **Frontend**: `https://frontend-<hash>.run.app`
*   **Backend**: `https://backend-<hash>.run.app`

---

## 🔍 Retrieving Deployment URLs

You can retrieve the actual deployment URLs by running the following commands in their respective infrastructure directories:

### AWS
```bash
cd infra/aws
terraform output alb_dns
```

### GCP
```bash
cd infra/gcp
terraform output frontend_url
terraform output backend_url
```

---

## ☁️ Infrastructure Details
The GCP setup leverages serverless technologies for rapid deployment and ease of management.

#### Components:
*   **Cloud Run**: Fully managed serverless platform for running the frontend and backend containers.
*   **Artifact Registry**: Secure storage for Docker images.
*   **IAM**: Fine-grained access control using dedicated Service Accounts for each service.

> [!NOTE]
> **Architecture Diagrams**
> 
> **AWS Infrastructure Diagram**
> (Insert Diagram Here)
> 
> **GCP Infrastructure Diagram**
> (Insert Diagram Here)

---

## 🛠️ Local Development

To run the entire stack locally using Docker Compose:

```bash
docker-compose up --build
```

The frontend will be available at `http://localhost:3000` and the backend at `http://localhost:8000`on the local machine
