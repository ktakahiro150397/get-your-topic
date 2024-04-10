# Base image
FROM python:latest

WORKDIR /workspace

COPY . /workspace

# Setup Python
RUN pip install --upgrade pip \
    pip install --upgrade setuptools

# Install Python dependencies
RUN pip install -r requirements.txt && \
    pip install uvicorn pillow

CMD ["uvicorn", "main:app", "--port","80","--host","0.0.0.0"]
