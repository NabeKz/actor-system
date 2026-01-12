FROM debian:bookworm-slim AS builder

RUN apt-get update && apt-get install -y \
    curl \
    git \
    build-essential \
    autoconf \
    libssl-dev \
    libncurses5-dev \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN curl https://mise.run | sh
ENV PATH="/root/.local/bin:${PATH}"

WORKDIR /app

COPY .mise.toml .

RUN mise install

COPY gleam.toml manifest.toml ./
COPY src ./src

RUN mise exec -- gleam build

FROM erlang:27-slim

WORKDIR /app

COPY --from=builder /app/build /app/build
COPY --from=builder /root/.local/share/mise/installs/gleam /usr/local/gleam

ENV PATH="/usr/local/gleam/latest/bin:${PATH}"
ENV PORT=5000

EXPOSE 5000

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:5000/ || exit 1

CMD ["gleam", "run"]
