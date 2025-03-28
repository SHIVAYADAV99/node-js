# Use official Node.js image as base
FROM node:18-alpine AS builder

# Set working directory inside container
WORKDIR /app

# Copy package.json and package-lock.json to install dependencies
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install

# # Set base path environment variable
# ARG VITE_BASE_PATH=/ops-fe/
# ENV VITE_BASE_PATH=$VITE_BASE_PATH

# ENV VITE_BASE_PATH=/ops-fe/

# Copy all project files
COPY . .

# Build the Vue.js app with the base path
RUN npm run build

# Use Nginx to serve the built files
FROM nginx:alpine

# Set working directory inside Nginx
WORKDIR /usr/share/nginx/html

# # Remove default Nginx static assets
# RUN rm -rf ./*

# Copy built files from the builder stage
COPY --from=builder /app/dist .

# Copy custom Nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
