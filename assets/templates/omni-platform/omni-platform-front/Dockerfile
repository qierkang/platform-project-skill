FROM node:20-alpine AS builder

WORKDIR /app

COPY package.json tsconfig.json vite.config.ts index.html ./
COPY src ./src
RUN npm install -g pnpm@10.33.2 && pnpm install && pnpm build

FROM node:20-alpine

WORKDIR /app

RUN npm install -g serve@14.2.4
COPY --from=builder /app/dist ./dist

EXPOSE 7061

CMD ["sh", "-c", "serve -l 7061 -s dist"]
