# Builder
FROM elixir:1.11.4-alpine AS builder

WORKDIR /app

ENV MIX_ENV=prod

RUN apk add --no-cache build-base git python2 yarn
RUN mix local.hex --force && \
  mix local.rebar --force

COPY mix.exs mix.lock ./
RUN mix do deps.get --only prod, deps.compile

COPY config config
COPY lib lib
# See excluded files in .dockerignore for priv and assets:
COPY priv priv
COPY assets assets

RUN yarn --cwd ./assets install --frozen-lockfile && \
      yarn --cwd ./assets run deploy && \
      mix phx.digest

RUN mix do compile, release

# Prod
FROM alpine AS prod

ARG APP_NAME=yeboster

EXPOSE 4000

ENV HOME=/app

WORKDIR /app

RUN apk add --no-cache openssl ncurses-libs && \
  chown nobody:nobody /app

COPY ./docker-entrypoint.sh .
RUN chmod +x /app/docker-entrypoint.sh
ENTRYPOINT ["/app/docker-entrypoint.sh"]

USER nobody:nobody
COPY --from=builder --chown=nobody:nobody /app/_build/prod/rel/$APP_NAME ./

RUN ln -s /app/bin/$APP_NAME /app/bin/start_script

CMD ["bin/start_script", "start"]
