# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :yeboster,
  ecto_repos: [Yeboster.Repo]

# Configures the endpoint
config :yeboster, YebosterWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "S3OstmmARQwCpjs9ux+2dgP1OjarExCPOnPNCr3EVEZDB1VsnEpU/OINAMPl1xsT",
  render_errors: [view: YebosterWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Yeboster.PubSub,
  live_view: [signing_salt: "GkEjjr1x5mKFg+F5Qtg9Brmnajt7xSOJ"]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.41",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
