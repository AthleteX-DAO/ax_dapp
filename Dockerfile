# Install Operating system and dependencies
FROM ubuntu:20.04

# args
ARG PORT
ARG BUILD_TYPE

# To prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update 
RUN apt-get install -y curl git wget unzip libgconf-2-4 gdb libstdc++6 libglu1-mesa fonts-droid-fallback lib32stdc++6 python3 psmisc
RUN apt-get clean

# download Flutter SDK from Flutter Github repo
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter

# Set flutter environment path
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

EXPOSE ${PORT}
RUN echo "Launching ${BUILD_TYPE} App on Port: ${PORT}"

# Run flutter doctor
RUN flutter doctor

# Enable flutter web
RUN flutter channel stable
RUN flutter upgrade
RUN flutter config --enable-web

# Copy files to container and build
RUN mkdir /app/
COPY . /app/
WORKDIR /app/
RUN flutter pub get
RUN flutter build web --dart-define=BUILD_TYPE=${BUILD_TYPE} --web-renderer auto

# make server startup script executable and start the web server
RUN ["chmod", "+x", "/app/server/server.sh"]

ENTRYPOINT [ "/app/server/server.sh"]
