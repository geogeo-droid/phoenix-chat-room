defmodule TomboChatWeb.PageControllerTest do
  use TomboChatWeb.ConnCase, async: false
  import Phoenix.LiveViewTest

  test "test user authentication on all actions", %{conn: conn} do
    Enum.each(
      [
        get(conn, Routes.page_path(conn, :index))
      ],
      fn
        conn ->
          assert html_response(conn, 302)
          assert conn.halted
      end
    )
  end

  describe "with a logged-in user" do
    setup %{conn: conn, login_as: username} do
      user = user_fixture(username: username)
      conn = assign(conn, :current_user, user)

      {:ok, conn: conn}
    end

    @tag login_as: "test-man"
    test "access index page", %{conn: conn} do
      room = room_fixture(roomname: "lobby", name: "ロビー")

      {:ok, view, html} =
        live_isolated(conn, TomboChatWeb.Rooms,
          session: %{"current_user" => conn.assigns.current_user}
        )

      assert html =~ "Rooms"
      assert html =~ "Messages"
      assert html =~ "Members"
    end
  end
end
