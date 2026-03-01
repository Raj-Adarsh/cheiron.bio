# syntax=docker/dockerfile:1
FROM python:3.12-slim

WORKDIR /app


COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY service_a/service_a.py ./

ENV FLASK_ENV=production

CMD ["python", "service_a.py"]
