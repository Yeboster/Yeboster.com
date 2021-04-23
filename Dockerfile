# Builder
FROM elixir:1.11.4-alpine AS builder

WORKDIR /app

ENV MIX_ENV=prod

RUN apk add --no-cache build-base git python3 yarn && \
  mix local.hex --force && \
  mix local.rebar --force

COPY mix.exs mix.lock ./
COPY config config
COPY lib lib
# See excluded files in .dockerignore for priv and assets:
COPY priv priv
COPY assets assets

RUN mix do deps.get --only prod, deps.compile && \
  yarn --cwd ./assets install --frozen-lockfile && \
  yarn --cwd ./assets run deploy && \
  mix phx.digest && \
  mix do compile, release

# Prod
FROM alpine AS prod

ARG APP_NAME=yeboster

EXPOSE 4000

ENV HOME=/app
ENV REPLACE_OS_VARS=true

WORKDIR /app
ENTRYPOINT ./docker-entrypoint.sh

RUN apk add --no-cache openssl ncurses-libs && \
  chown nobody:nobody /app

USER nobody:nobody
COPY --from=builder --chown=nobody:nobody /app/_build/prod/rel/$APP_NAME ./

CMD ["bin/${APP_NAME}", "start"]
