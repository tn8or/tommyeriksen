# Stage 1: Build the Hugo site
FROM ghcr.io/gohugoio/hugo:v0.168.0 AS builder
WORKDIR /src
COPY . .
# .git is excluded from the build context, so the source revision has to be
# passed in. CI sets this to github.sha. Locally:
#   docker build --build-arg GIT_COMMIT=$(git rev-parse HEAD) .
ARG GIT_COMMIT=
ENV HUGO_PARAMS_commit=${GIT_COMMIT}
# Empty = production (baseURL from hugo.toml, future-dated posts left out).
# PR builds set the staging URL: links and og:image point at staging,
# future-dated posts are included so they can be previewed, and the site is
# noindex (params.staging).
ARG STAGING_URL=
RUN if [ -n "$STAGING_URL" ]; then \
      HUGO_PARAMS_staging=true hugo --minify --baseURL "$STAGING_URL" --buildFuture; \
    else \
      hugo --minify; \
    fi

# Stage 2: Serve with nginx
FROM nginx:1.31.8-alpine
COPY --from=builder /src/public /usr/share/nginx/html
COPY nginx/nginx.conf /etc/nginx/nginx.conf
EXPOSE 80
