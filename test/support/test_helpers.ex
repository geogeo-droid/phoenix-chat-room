defmodule TomboChat.TestHelpers do
  alias TomboChat.{Accounts, Spaces}

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        name: "Test User",
        username: "user#{System.unique_integer([:positive])}",
        password: attrs[:password] || "super_secret",
        admin: false
      })
      |> Accounts.register_user()

    user
  end

  def room_fixture(attrs \\ %{}) do
    attrs =
      # Enum.intoはattrsにあるものは変更しない
      Enum.into(attrs, %{
        name: "TestRoom",
        roomname: "test"
      })

    {:ok, room} = Spaces.create_room(attrs)

    room
  end
end