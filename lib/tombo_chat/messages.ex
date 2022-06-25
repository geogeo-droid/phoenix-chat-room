defmodule TomboChat.Messages do
  import Ecto.Query

  alias TomboChat.Repo
  alias TomboChat.Messages.Message
  alias TomboChat.Spaces.Room

  def change_message() do
    Message.changeset(%Message{})
  end

  def create_message(room_id, user_id, attrs) do
    %Message{room_id: room_id, user_id: user_id}
    |> Message.changeset(attrs)
    |> Repo.insert()
  end

  def list_messages(%Room{} = room) do
    Repo.all(
      from a in Ecto.assoc(room, :messages),
        order_by: [asc: a.inserted_at],
        limit: 100,
        preload: [:user]
    )
  end

  def preload(%Message{} = message, opts) do
    Repo.preload(message, opts)
  end
end
