# Base image
FROM ubuntu:20.04 AS builder

# Install dependencies
RUN apt-get update && apt-get install -y git unzip curl

# Clone the flutter repo
RUN git clone https://github.com/flutter/flutter.git -b stable /usr/local/flutter

# Set flutter path
# RUN /usr/local/flutter/bin/flutter doctor -v
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Enable flutter web
RUN flutter channel master
RUN flutter upgrade
RUN flutter config --enable-web

# Copy files to container and build
RUN mkdir /app
COPY . /app
WORKDIR /app
RUN flutter build web --release

# Start Nginx
FROM nginx:1.21.1-alpine
COPY --from=builder /app/build/web /usr/share/nginx/html