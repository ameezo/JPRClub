# Build stage
FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
# The VITE_API_URL is baked in during build. For Cloudflare Tunnels where 
# the API is hosted under the same domain (e.g. yourdomain.com/api), 
# a relative path /api is perfect.
ENV VITE_API_URL=/api
RUN npm run build

# Serve stage
FROM nginx:alpine
# Copy the build output to Nginx's HTML folder
COPY --from=build /app/dist /usr/share/nginx/html
# Copy a custom Nginx configuration if needed for React Router fallback
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
