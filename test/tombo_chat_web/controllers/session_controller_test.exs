defmodule TomboChatWeb.SessionControllerTest do
  use TomboChatWeb.ConnCase, async: true

  test "requires user authentication on all actions", %{conn: conn} do
    Enum.each(
      [
        delete(conn, Routes.session_path(conn, :delete, 1))
      ],
      fn
        conn ->
          assert html_response(conn, 302)
          assert conn.halted
      end
    )
  end
end
