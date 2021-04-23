# Builder
FROM elixir:1.11.4 AS builder

WORKDIR /app

ENV MIX_ENV=prod

RUN apk add --no-cache build-base npm git python3 && \
  mix local.hex --force && \
  mix local.rebar --force

COPY mix.exs mix.lock ./
COPY config config
COPY lib lib
COPY rel rel
# See excluded files in .dockerignore for priv and assets:
COPY priv priv
COPY assets assets

RUN mix do deps.get --only prod, deps.compile && \
  npm --prefix ./assets ci --progress=false --no-audit --loglevel=error && \
  npm run --prefix ./assets deploy && \
  mix phx.digest && \
  mix do compile, release

# Prod
FROM alpine AS prod

ARG APP_NAME=yeboster

WORKDIR /app
EXPOSE 4000

RUN apk add --no-cache openssl ncurses-libs && \
  chown nobody:nobody /app

USER nobody:nobody
COPY --from=builder --chown=nobody:nobody /app/_build/prod/rel/$APP_NAME ./
ENV HOME=/app

ENTRYPOINT ./docker-entrypoint.sh

CMD ["bin/${APP_NAME}", "start"]
