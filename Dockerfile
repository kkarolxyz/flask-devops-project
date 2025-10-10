# 1: Builder phase
FROM python:3.11-slim AS builder

WORKDIR /app


RUN apt-get update && apt-get install -y --no-install-recommends \
    && apt-get clean && rm -rf /var/lib/apt/lists/*


COPY requirements.txt .


RUN pip install --user --no-cache-dir -r requirements.txt

# Etap 2: Final image
FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

RUN adduser --disabled-password --gecos "" \
    --home "/nonexistent" --shell "/sbin/nologin" \
    --no-create-home --uid "10001" appuser

COPY --from=builder /root/.local /root/.local
ENV PATH=/root/.local/bin:$PATH

COPY . .

USER appuser

EXPOSE 5000

CMD ["python", "app.py"]