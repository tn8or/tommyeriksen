# Stage 1: Build the Hugo site
FROM hugomods/hugo:0.165.0 AS builder
WORKDIR /src
COPY . .
RUN hugo --minify

# Stage 2: Serve with nginx
FROM nginx:alpine
COPY --from=builder /src/public /usr/share/nginx/html
COPY nginx/nginx.conf /etc/nginx/nginx.conf
EXPOSE 80
