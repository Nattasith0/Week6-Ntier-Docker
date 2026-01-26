# ============================================
# Dockerfile for Task Board API
# ENGSE207 - Week 6 Docker Version
# ============================================

# Base image (small)
FROM node:20-alpine

# Metadata
LABEL maintainer="ENGSE207 Student"
LABEL description="Task Board API - N-Tier Architecture"
LABEL version="2.0.0"

# Working directory
WORKDIR /app

# Copy package files first (layer caching)
COPY package*.json ./

# Install production dependencies only
RUN npm ci --omit=dev

# Copy source code
COPY . .

# Install wget for HEALTHCHECK (Alpine may not include it)
RUN apk add --no-cache wget

# Create non-root user for security + set ownership
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001 -G nodejs && \
    chown -R nodejs:nodejs /app

# Use non-root user
USER nodejs

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:3000/api/health || exit 1

# Start command
CMD ["node", "server.js"]
