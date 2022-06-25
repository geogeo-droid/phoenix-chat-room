# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :tombo_chat,
  ecto_repos: [TomboChat.Repo]

# Configures the endpoint
config :tombo_chat, TomboChatWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "d5tdRp3DhQp1A/aHkNJOTJu+SSGWqEZnz9dCefjS9XF/Xcb+X+7fB3iVMcCnwB6J",
  render_errors: [view: TomboChatWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: TomboChat.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [
    signing_salt: "pRrAl1Ths+KhHxsijcxnNgHJ0hqeoGQg"
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :git_hooks,
  verbose: true,
  hooks: [
    pre_commit: [
      tasks: [
        "mix format",
        # "mix credo --strict",
        # "mix doctor --summary",
        "mix test"
      ]
    ],
    pre_push: [
      tasks: []
    ]
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
