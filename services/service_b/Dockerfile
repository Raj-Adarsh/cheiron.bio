# syntax=docker/dockerfile:1
FROM python:3.12-slim
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
COPY service_b/service_b.py ./
ENV FLASK_ENV=production
CMD ["python", "service_b.py"]
