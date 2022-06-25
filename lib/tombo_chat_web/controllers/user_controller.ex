defmodule TomboChatWeb.UserController do
  use TomboChatWeb, :controller
  plug :authenticate_user when action in [:index, :show, :edit, :update, :delete]
  plug :allow_only_admin when action in [:index, :delete]

  plug :put_layout, "admin_setting.html"

  alias TomboChat.Accounts
  alias TomboChat.Accounts.User
  alias TomboChatWeb.Email
  alias TomboChatWeb.Mailer

  def index(conn, _params) do
    conn
    # TODO render関数についてまとめる
    |> render("index.html", users: Accounts.list_users())
  end

  def show(conn, %{"id" => id} = _params) do
    conn
    # |> IO.inspect()
    |> render("show.html", user: Accounts.get_user(id))
  end

  def new(conn, _params) do
    # returns an Ecto.Changeset
    changeset = Accounts.change_registration(%User{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params} = _params) do
    # params |> IO.inspect()
    # %{
    #   "_csrf_token" => "NysIBT4CDy4BFxofAB43aAgHEXVVbBQjErEfISfMtocydMN8IDZFg4FO",
    #   "_utf8" => "✓",
    #   "user" => %{"name" => "", "username" => ""}
    # }

    case Accounts.register_user(user_params) do
      # Repo.insertが成功したときの戻り値
      {:ok, user} ->
        Email.account_activation(user)
        |> Mailer.deliver_now()

        conn
        |> put_flash(:info, "Please check your email to activate your account.")
        |> redirect(to: Routes.page_path(conn, :index))

      # Repo.insertが失敗したときの戻り値
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> render("new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id} = _params) do
    user = Accounts.get_user(id)
    changeset = Accounts.change_user(user)

    conn
    |> render("edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params} = _params) do
    user = Accounts.get_user(id)

    case Accounts.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "#{user.name} user edit succeeded!")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> render("edit.html", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id} = _params) do
    case Accounts.delete_user(id) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "#{user.name} deleted!")
        |> redirect(to: Routes.user_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> render("index.html", changeset: changeset)
    end
  end
end
