defmodule TomboChat.Spaces do
  @moduledoc """
      The Spaces context.
  """

  alias TomboChat.Repo
  alias TomboChat.Spaces.Room

  def list_rooms() do
    Repo.all(Room)
  end

  def get_room(id) do
    Repo.get(Room, id)
  end

  def get_room!(id) do
    Repo.get!(Room, id)
  end

  def get_room_by(params) do
    Repo.get_by(Room, params)
  end

  def change_room(%Room{} = room) do
    Room.changeset(room, %{})
  end

  def create_room(attrs \\ %{}) do
    %Room{}
    |> Room.changeset(attrs)
    |> Repo.insert()
  end

  def update_room(%Room{} = room, attrs \\ %{}) do
    room
    |> Room.changeset(attrs)
    |> Repo.update()
  end

  def delete_room(id) do
    room = Repo.get(Room, id)
    Repo.delete(room)
  end
end