import Config

database_url =
  System.get_env("DATABASE_URL") ||
    raise """
    environment variable DATABASE_URL is missing.
    For example: ecto://USER:PASS@HOST/DATABASE
    """

config :yeboster, Yeboster.Repo,
  # ssl: true,
  url: database_url,
  database: "yeboster_prod"
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

live_view_signing_salt =
  System.fetch_env("LIVE_VIEW_SIGNING_SALT") ||
    raise """
    environment variable LIVE_VIEW_SIGNING_SALT is missing.
    You can generate one by calling: mix phx.gen.secret
    """

app_data_path =
  System.fetch_env("APP_DATA") || "/app/data"


config :yeboster, YebosterWeb.Endpoint,
  http: [
    port: String.to_integer(System.get_env("PORT") || "4000"),
    transport_options: [socket_opts: [:inet6]]
  ],
  live_view: [
    signing_salt: live_view_signing_salt
  ],
  secret_key_base: secret_key_base,
  url: [
    host: "yeboster.com",
    port: 443
  ],
  app_data_path: app_data_path
