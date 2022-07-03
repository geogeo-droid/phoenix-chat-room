defmodule TomboChat.Messages.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :body, :string
    belongs_to :user, TomboChat.Accounts.User
    belongs_to :room, TomboChat.Spaces.Room

    timestamps()
  end

  def changeset(message, attrs \\ %{}) do
    message
    |> cast(attrs, [:body])
    |> validate_required([:body])
  end
end