defmodule TomboChatWeb.AccountActivationController do
  use TomboChatWeb, :controller

  alias TomboChat.Accounts

  def edit(conn, %{"email" => email, "id" => token} = params) do
    case Accounts.authenticate_by_email_and_token(email, token) do
      {:ok, user} ->
        Accounts.activate(user)

        conn
        |> TomboChatWeb.Auth.login(user)
        |> put_flash(:success, "Account activated!")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Invalid activation link")
        |> redirect(to: Routes.page_path(conn, :index))
    end
  end
end
