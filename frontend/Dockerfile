# Stage 1: Build Flutter Web app
FROM ubuntu:20.04 AS build

# Install dependencies
RUN apt-get update && apt-get install -y curl git unzip xz-utils zip libglu1-mesa

# Install Flutter
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Run flutter doctor
RUN flutter doctor -v

# Copy app source code
WORKDIR /app
COPY . .

# Build web release
RUN flutter clean
RUN flutter pub get
RUN flutter build web --release

# Stage 2: Serve app
FROM node:18-alpine
WORKDIR /app
COPY --from=build /app/build/web ./build/web

# Install serve
RUN npm install -g serve

# Start serve
CMD serve -s build/web -l $PORT
