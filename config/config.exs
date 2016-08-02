# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :webpack_integration,
  ecto_repos: [WebpackIntegration.Repo]

# Configures the endpoint
config :webpack_integration, WebpackIntegration.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "LWHKeplT5zBoMQ4t/YT4ul6bjOf25gIlBMITH419jZ37JUKlHUr3bjcu6t24sRS5",
  render_errors: [view: WebpackIntegration.ErrorView, accepts: ~w(html json)],
  pubsub: [name: WebpackIntegration.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
