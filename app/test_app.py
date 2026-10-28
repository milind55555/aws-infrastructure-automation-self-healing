from app import app

def test_health_endpoint():
    client = app.test_client()
    response = client.get("/health")
    assert response.status_code == 200
    assert response.get_json()["status"] == "healthy"

def test_ready_endpoint():
    client = app.test_client()
    response = client.get("/ready")
    assert response.status_code == 200
    assert response.get_json()["ready"] is True
