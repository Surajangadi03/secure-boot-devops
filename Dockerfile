FROM python:3.11-slim

# Install tool needed to allow non-root to bind to port 80
RUN apt-get update && apt-get install -y libcap2-bin

# Create a non-root user
RUN useradd -m appuser

# Set working directory
WORKDIR /app

# Copy application code
COPY app/ /app/

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Allow uvicorn to bind to privileged port 80 without root
RUN setcap 'cap_net_bind_service=+ep' /usr/local/bin/uvicorn

# Switch to non-root user
USER appuser

# Expose port 80
EXPOSE 80

# Start the application
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "80"]

