from fastapi.testclient import TestClient
from app.main import app
import pytest

@pytest.fixture
def client():
    return TestClient(app)

def test_health(client):
    response = client.get("/api/health")
    assert response.status_code == 200
    assert response.json() == {
        "status": "healthy",
        "message":"Backend is running successfully"
    }


def test_get_message(client):
    response = client.get("/api/message")
    assert response.status_code == 200
    assert response.json() == {
        "message": "You've successfully integrated the backend!"
    }