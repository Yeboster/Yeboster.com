use Mix.Config

config :yeboster, Yeboster.Repo,
  # ssl: true,
  url: "${DATABASE_URL}",
  pool_size: 10


config :yeboster, YebosterWeb.Endpoint,
  http: [
    port: 4000,
    transport_options: [socket_opts: [:inet6]]
  ],
  live_view: [
    signing_salt: "${LIVE_VIEW_SIGNING_SALT}"
  ],
  secret_key_base: "${SECRET_KEY_BASE}",
  url: [
    host: "yeboster.me",
    port: 443
  ],
  app_data_path: "${APP_DATA_PATH}"

