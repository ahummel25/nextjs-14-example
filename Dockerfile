FROM imbios/bun-node:20-slim AS deps

WORKDIR /app

# Install dependencies based on the preferred package manager
COPY package.json bun.lockb ./
RUN bun install --frozen-lockfile

# Build the app
FROM deps AS builder
WORKDIR /app
COPY . .

RUN bun run build


# Production image, copy all the files and run next
FROM imbios/bun-node:20-slim AS runner
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update && \
  apt-get install -y curl && \
  apt-get install -y git && \
  apt-get install -y openssh-server && \
  apt-get install -yq openssl git ca-certificates tzdata && \
  ln -fs /usr/share/zoneinfo/US/Central /etc/localtime && \
  dpkg-reconfigure -f noninteractive tzdata

WORKDIR /app

ARG CONFIG_FILE
COPY $CONFIG_FILE /app/.env
ENV NODE_ENV production
# Uncomment the following line in case you want to disable telemetry during runtime.
# ENV NEXT_TELEMETRY_DISABLED 1

COPY --from=builder  /app ./

RUN ["chmod", "+x", "/usr/local/bin/docker-entrypoint.sh"]

EXPOSE 3001

ENV PORT 3001

CMD ["bun", "run", "start"]
