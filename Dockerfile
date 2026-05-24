# ── STAGE 1: BUILD ─────────────────────────────
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# ── STAGE 2: RUNTIME ────────────────────────────
FROM nginx:stable-alpine
WORKDIR /usr/share/nginx/html
COPY --from=builder /app/dist .
COPY nginx.conf /etc/nginx/conf.d/default.conf
RUN rm -rf /var/cache/apk/*
EXPOSE 80
CMD ["nginx","-g","daemon off;"]