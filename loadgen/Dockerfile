# Get the base image of Node version 16
#FROM node:16

# Get the latest version of Playwright
#FROM --platform=linux/amd64 mcr.microsoft.com/playwright:v1.44.1-jammy
FROM mcr.microsoft.com/playwright:v1.54.1

# FROM node:20-bookworm
# Get the needed libraries to run Playwright
RUN apt-get update && apt-get -y install libnss3 libatk-bridge2.0-0 libdrm-dev libxkbcommon-dev libgbm-dev libasound-dev libatspi2.0-0 libxshmfence-dev
RUN npm install -g lorem-ipsum 
# Set the work directory for the application
WORKDIR /app

# COPY the needed files to the app folder in Docker image
COPY package.json /app/
COPY e2e /app/e2e
COPY playwright.config.ts /app/
# Install the dependencies in Node environment
RUN npm install
RUN npx -y playwright@1.54.1 install --with-deps
 
 
# Set the environment path to node_modules/.bin
ENV PATH=/app/node_modules/.bin:$PATH

#COPY tsconfig.json /app/
#COPY config.toml /app/


#RUN npm run test
ENTRYPOINT ["npx", "playwright", "test"]
