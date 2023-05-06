# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :plate_slate,
  ecto_repos: [PlateSlate.Repo]

# Configures the endpoint
config :plate_slate, PlateSlateWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [json: PlateSlateWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: PlateSlate.PubSub,
  live_view: [signing_salt: "Q3/GdpZ4"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Configures Comeonin Ecto Password
config :comeonin, Ecto.Password, Pbkdf2
config :comeonin, :pbkdf2_rounds, 120_000
config :comeonin, :pbkdf2_salt_len, 512

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
