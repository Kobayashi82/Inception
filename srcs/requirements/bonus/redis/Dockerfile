# Debian image
FROM debian:bullseye

# Install PHP & wget
RUN apt-get update && apt-get install -y redis-server

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Create config file
ARG REDIS_PASSWORD
RUN echo "requirepass ${REDIS_PASSWORD}" > /etc/redis/redis.conf

# Execute Redis
ENTRYPOINT ["redis-server", "/etc/redis/redis.conf"]

EXPOSE 6379
