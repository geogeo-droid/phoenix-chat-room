defmodule TomboChat.Repo do
  use Ecto.Repo,
    otp_app: :tombo_chat,
    adapter: Ecto.Adapters.Postgres
end
