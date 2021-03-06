defmodule TomboChatWeb.SessionController do
  use TomboChatWeb, :controller
  plug :authenticate_user when action in [:delete]

  def new(conn, _) do
    conn
    |> render("new.html")
  end

  def create(
        conn,
        %{"session" => %{"username" => username, "password" => pass}}
      ) do
    case TomboChat.Accounts.authenticate_by_username_and_pass(username, pass) do
      {:ok, user} ->
        conn
        |> TomboChatWeb.Auth.login(user)
        |> put_flash(:info, "Welcome back!")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Invalid username/password combination")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> TomboChatWeb.Auth.logout()
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
