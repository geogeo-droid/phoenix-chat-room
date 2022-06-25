defmodule TomboChatWeb.UserControllerTest do
  use TomboChatWeb.ConnCase, async: true

  test "requires user authentication on all actions", %{conn: conn} do
    Enum.each(
      [
        get(conn, Routes.user_path(conn, :index)),
        get(conn, Routes.user_path(conn, :show, 1)),
        get(conn, Routes.user_path(conn, :edit, 1)),
        put(conn, Routes.user_path(conn, :update, 1), %{}),
        delete(conn, Routes.user_path(conn, :delete, 1))
      ],
      fn
        conn ->
          assert redirected_to(conn, 302) == "/sessions/new"
          assert conn.halted
      end
    )
  end

  test "register view", %{conn: conn} do
    conn = get(conn, Routes.user_path(conn, :new))
    assert html_response(conn, 200) =~ "<p class=\"title\">Register</p>"
  end

  test "register invalid user information", %{conn: conn} do
    conn = post(conn, Routes.user_path(conn, :create), %{"user" => %{}})
    assert html_response(conn, 200) =~ "something went wrong"
  end

  test "register valid user information", %{conn: conn} do
    attrs = user_attributes()

    conn =
      post(conn, Routes.user_path(conn, :create), %{
        "user" => %{
          name: attrs.name,
          username: attrs.username,
          email: attrs.email,
          password: attrs.password
        }
      })

    assert redirected_to(conn, 302) == "/"
    assert get_flash(conn, :info) =~ "Please check your email to activate your account."
  end
end
