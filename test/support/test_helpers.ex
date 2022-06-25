defmodule TomboChat.TestHelpers do
  alias TomboChat.{Accounts, Spaces}

  def user_attributes(attrs \\ %{}) do
    attrs
    |> Enum.into(%{
      name: "Test User",
      username: "user#{System.unique_integer([:positive])}",
      email: "test@example.com",
      password: attrs[:password] || "super_secret"
    })
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> user_attributes()
      |> Accounts.register_user()

    user
  end

  def admin_user_fixture(attrs \\ %{}) do
    {:ok, admin} =
      attrs
      |> user_attributes()
      |> Accounts.register_admin_user()

    admin
  end

  def room_fixture(attrs \\ %{}) do
    # Enum.intoはattrsにあるものは変更しない
    attrs =
      Enum.into(attrs, %{
        name: "TestRoom",
        roomname: "test"
      })

    {:ok, room} = Spaces.create_room(attrs)

    room
  end
end
