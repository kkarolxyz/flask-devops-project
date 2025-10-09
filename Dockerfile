FROM python:3.11-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

#Working directory 

WORKDIR /app

#Non root user
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/nonexistent" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid "10001" \
    appuser

#Copy req file
COPY requirements.txt .

#Install req
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

USER appuser

EXPOSE  5000

CMD [ "python", "app.py" ]