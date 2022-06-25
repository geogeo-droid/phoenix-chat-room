defmodule TomboChat.Spaces.Room do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rooms" do
    # unique in system
    field :roomname, :string
    field :name, :string

    has_many :messages, TomboChat.Messages.Message

    timestamps()
  end

  def changeset(room, attrs) do
    room
    |> cast(attrs, [:name, :roomname])
    |> validate_required([:name, :roomname])
    |> validate_length(:roomname, min: 1, max: 20)
    |> unique_constraint(:roomname)
  end
end
