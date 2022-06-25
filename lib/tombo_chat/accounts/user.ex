defmodule TomboChat.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  # From the schema definition,
  # Ecto automatically defines an Elixir struct, %TomboChat.Accounts.User{}

  schema "users" do
    # unique in system
    field :username, :string

    field :name, :string
    field :email, :string

    # virtual schema field exists only in the struct, not the database
    field :password, :string, virtual: true
    field :password_hash, :string

    field :activation_token, :string, virtual: true
    field :activation_hash, :string
    field :activated, :boolean
    field :activated_at, :naive_datetime

    field :admin, :boolean

    timestamps()
  end

  def changeset(user, attrs) do
    user
    # userの[:name, :username]にattrsの変更を適用し、changesetを返す
    |> cast(attrs, [:name, :username])
    |> validate_required([:name, :username])
    |> validate_length(:username, min: 1, max: 20)
    |> unique_constraint(:username)
  end

  @valid_email_regex ~r/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/
  def registration_changeset(user, params) do
    user
    |> changeset(params)
    |> cast(params, [:password, :email])
    |> validate_required([:password, :email])
    |> validate_format(:email, @valid_email_regex)
    |> validate_length(:password, min: 8, max: 100)
    |> put_pass_hash()
    |> put_activation_token_and_hash()
  end

  def administrator_changeset(user, params) do
    user
    |> registration_changeset(params)
    |> cast(params, [:admin])
    |> validate_required([:admin])
  end

  def activation_changeset(user, params) do
    user
    |> cast(params, [:activated, :activated_at])
    |> validate_required([:activated, :activated_at])
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Pbkdf2.hash_pwd_salt(pass))

      _ ->
        changeset
    end
  end

  defp put_activation_token_and_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true} ->
        # see https://github.com/phoenixframework/phoenix/blob/master/lib/mix/tasks/phx.gen.secret.ex
        # literal copy of mix phx.gen.secret implementation.
        length = 64
        token = :crypto.strong_rand_bytes(length) |> Base.encode64() |> binary_part(0, length)

        changeset
        |> put_change(:activation_token, token)
        |> put_change(:activation_hash, Pbkdf2.hash_pwd_salt(token))

      _ ->
        changeset
    end
  end
end
