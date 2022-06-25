defmodule TomboChat.Accounts do
  @moduledoc """
    The Accounts context.
  """

  import Ecto.Query

  alias TomboChat.Repo
  alias TomboChat.Accounts.User

  def list_users do
    Repo.all(User)
  end

  def list_users_with_ids(ids) do
    Repo.all(from(u in User, where: u.id in ^ids))
  end

  def get_user(id) do
    Repo.get(User, id)
  end

  def get_user!(id) do
    Repo.get!(User, id)
  end

  def get_user_by(params) do
    Repo.get_by(User, params)
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs \\ %{}) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def delete_user(id) do
    user = Repo.get(User, id)
    Repo.delete(user)
  end

  def activate(%User{} = account) do
    account
    |> User.activation_changeset(%{activated: true, activated_at: NaiveDateTime.utc_now()})
    |> Repo.update()
  end

  def change_registration(%User{} = user, params) do
    User.registration_changeset(user, params)
  end

  def register_user(attrs \\ %{}) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  def register_admin_user(attrs \\ %{}) do
    %User{}
    |> User.administrator_changeset(attrs)
    |> Repo.insert()
  end

  def authenticate_by_username_and_pass(username, given_pass) do
    user = get_user_by(username: username)

    cond do
      user && Pbkdf2.verify_pass(given_pass, user.password_hash) ->
        {:ok, user}

      user ->
        {:error, :unauthorized}

      true ->
        # for timing attacks
        Pbkdf2.no_user_verify()
        {:error, :not_found}
    end
  end

  def authenticate_by_email_and_token(email, given_token) do
    user = get_user_by(email: email)

    cond do
      user && Pbkdf2.verify_pass(given_token, user.activation_hash) ->
        {:ok, user}

      user ->
        {:error, :unauthorized}

      true ->
        # for timing attacks
        Pbkdf2.no_user_verify()
        {:error, :not_found}
    end
  end
end
