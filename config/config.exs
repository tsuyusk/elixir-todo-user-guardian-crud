# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :todo,
  ecto_repos: [Todo.Repo]

# Configures the endpoint
config :todo, TodoWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "N69ySM1tYYCvgHKXAysBdS/HbSZAv9hRzkeN63H/aOWoFZa5sWdxdVoef1g3e8VI",
  render_errors: [view: TodoWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Todo.PubSub,
  live_view: [signing_salt: "FtbZaRs3"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :todo, TodoWeb.Auth.Guardian,
  issuer: "todo",
  secret_key: "GSdy4wWgUVfD2lzF7mIEMTmx4kpOfV5DDUkKcu4Rr7wSDjxLBHPOsRc7zv9dN9gV",
  serializer: Todo.GuardianSerializer

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
