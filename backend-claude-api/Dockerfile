# Base image
FROM python:latest

WORKDIR /workspace

COPY . /workspace

# Setup Python
RUN pip install --upgrade pip \
    pip install --upgrade setuptools

# Install Python dependencies
RUN pip install -r requirements.txt && \
    pip install uvicorn pillow sse_starlette

CMD ["uvicorn", "main:app", "--port","8000","--host","0.0.0.0"]
