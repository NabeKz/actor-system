FROM erlang:27-alpine AS build

RUN apk add --no-cache build-base

COPY --from=ghcr.io/gleam-lang/gleam:v1.14.0-erlang-alpine /bin/gleam /bin/gleam

WORKDIR /app

COPY gleam.toml manifest.toml ./
COPY src ./src

RUN gleam export erlang-shipment

FROM erlang:27-alpine

RUN apk add --no-cache curl

WORKDIR /app

COPY --from=build /app/build/erlang-shipment /app

ENV PORT=5000

EXPOSE 5000

# HEALTHCHECK --interval=30s --timeout=3s --start-period=30s --retries=3 \
#     CMD curl -f http://localhost:5000/ || exit 1

ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["run"]
