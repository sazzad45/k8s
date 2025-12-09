# -------------------------
# Stage 1: Build / Install Dependencies
# -------------------------
FROM python:3.7-slim AS builder

# Set working directory
WORKDIR /app

# Copy only requirements first (better cache)
COPY requirements.txt .

# Install dependencies in a dedicated folder
RUN pip install --no-cache-dir -r requirements.txt

# Copy application source code
COPY . .

# -------------------------
# Stage 2: Final Runtime Image
# -------------------------
FROM python:3.7-slim

WORKDIR /app

# Copy installed dependencies from builder
COPY --from=builder /root/.local /root/.local

# Update PATH to include pip installed packages
ENV PATH=/root/.local/bin:$PATH

# Copy application code
COPY --from=builder /app /app

# Expose port
EXPOSE 5000

# Run the app
CMD ["python", "main.py"]
