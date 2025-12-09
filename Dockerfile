# -------------------------
# Stage 1: Builder
# -------------------------
FROM python:3.7-slim AS builder

WORKDIR /app

# Copy requirements first (Docker cache optimization)
COPY requirements.txt .

# Install dependencies in a user directory
RUN python -m pip install --upgrade pip \
    && pip install --user --no-cache-dir -r requirements.txt

# Copy source code
COPY . .

# -------------------------
# Stage 2: Final runtime image
# -------------------------
FROM python:3.7-slim

WORKDIR /app

# Copy installed packages from builder
COPY --from=builder /root/.local /root/.local

# Update PATH so Python can find the installed packages
ENV PATH=/root/.local/bin:$PATH

# Copy application code
COPY --from=builder /app /app

# Expose port
EXPOSE 5000

# Run the app
CMD ["python", "main.py"]
