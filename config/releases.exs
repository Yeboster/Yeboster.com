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
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
  server: true

secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
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
    signing_salt: "WWsR57zOeo31u/Tr26kzAv7i/RZJu1jl"
  ],
  secret_key_base: secret_key_base,
  url: [
    host: "yeboster.me",
    port: 80
  ],
  app_data_path: app_data_path
