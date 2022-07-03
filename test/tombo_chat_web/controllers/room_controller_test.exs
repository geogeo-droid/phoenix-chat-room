defmodule TomboChatWeb.RoomControllerTest do
  use TomboChatWeb.ConnCase, async: true

  test "requires user authentication on all actions", %{conn: conn} do
    Enum.each(
      [
        get(conn, Routes.room_path(conn, :index)),
        get(conn, Routes.room_path(conn, :edit, 1)),
        get(conn, Routes.room_path(conn, :new)),
        get(conn, Routes.room_path(conn, :show, 1)),
        post(conn, Routes.room_path(conn, :create, %{})),
        put(conn, Routes.room_path(conn, :update, 1, %{})),
        delete(conn, Routes.room_path(conn, :delete, 1)),
      ],
      fn
        conn ->
        assert html_response(conn, 302)
        assert conn.halted
      end
    )
  end

  describe "with a user has administrator rights" do

    setup %{conn: conn, login_as: username} do
      user = user_fixture(username: username, admin: true)
      conn = assign(conn, :current_user, user)

      {:ok, conn: conn}
    end

    @tag login_as: "test-man"
    test "lists all rooms on index", %{conn: conn} do
      room = room_fixture(roomname: "existed")

      conn = get(conn, Routes.room_path(conn, :index))
      assert String.contains?(conn.resp_body, room.roomname)
    end

  end
end