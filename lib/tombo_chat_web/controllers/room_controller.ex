defmodule TomboChatWeb.RoomController do
  use TomboChatWeb, :controller
  plug :allow_only_admin when action in [:index, :edit, :new, :show, :create, :update, :delete]

  alias TomboChat.Spaces
  alias TomboChat.Spaces.Room

  def index(conn, _params) do
    rooms =
      Spaces.list_rooms()
      # |> IO.inspect

    conn
    |> render("index.html", rooms: rooms)
  end

  def show(conn, %{"id" => id} = _params) do
    conn
    |> render("show.html", room: Spaces.get_room(id))
  end

  def new(conn, _params) do
    changeset = Spaces.change_room(%Room{})

    conn
    |> render("new.html", changeset: changeset)
  end

  def create(conn, %{"room" => room_params} = _params) do
    case Spaces.create_room(room_params) do
      {:ok, room} ->
        conn
        |> put_flash(:info, "#{room.name} room created!")
        |> redirect(to: Routes.room_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> render("new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id} = _params) do
    room = Spaces.get_room(id)
    changeset = Spaces.change_room(room)

    conn
    |> render("edit.html", room: room, changeset: changeset)
  end

  def update(conn, %{"id" => id, "room" => room_params} = _params) do
    room = Spaces.get_room(id)

    case Spaces.update_room(room, room_params) do
      {:ok, room} ->
        conn
        |> put_flash(:info, "#{room.name} room edit succeeded!")
        |> redirect(to: Routes.room_path(conn, :show, room))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> render("edit.html", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id} = _params) do
    case Spaces.delete_room(id) do
      {:ok, room} ->
        conn
        |> put_flash(:info, "#{room.name} deleted!")
        |> redirect(to: Routes.room_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> render("index.html", changeset: changeset)
    end
  end

end
