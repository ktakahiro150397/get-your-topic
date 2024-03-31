# Base image
FROM python:latest

WORKDIR /workspace

COPY /backend-claude-api /workspace/backend-claude-api

# Setup Python
RUN pip install --upgrade pip \
    pip install --upgrade setuptools

# Install Python dependencies
COPY backend-claude-api/requirements.txt requirements.txt
RUN pip install -r requirements.txt && \
    pip install uvicorn pillow

WORKDIR /workspace/backend-claude-api
CMD ["uvicorn", "main:app", "--reload","--port","8000"]
