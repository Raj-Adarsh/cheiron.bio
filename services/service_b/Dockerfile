# syntax=docker/dockerfile:1
FROM python:3.12-slim

WORKDIR /app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY service_b/service_b.py ./

ENV FLASK_ENV=production

CMD ["python", "service_b.py"]
