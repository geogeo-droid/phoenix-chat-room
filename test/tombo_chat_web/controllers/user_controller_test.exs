defmodule TomboChatWeb.UserControllerTest do
  use TomboChatWeb.ConnCase, async: true

  test "requires user authentication on all actions", %{conn: conn} do
    Enum.each(
      [
        get(conn, Routes.user_path(conn, :index)),
        get(conn, Routes.user_path(conn, :show, 1)),
        get(conn, Routes.user_path(conn, :edit, 1)),
        put(conn, Routes.user_path(conn, :update, 1, %{})),
        delete(conn, Routes.user_path(conn, :delete, 1)),
      ],
      fn
        conn ->
        assert html_response(conn, 302)
        assert conn.halted
      end
    )
  end

end