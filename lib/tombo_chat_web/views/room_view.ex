defmodule TomboChatWeb.RoomView do
  use TomboChatWeb, :view

  alias TomboChat.Accounts.User

  def get_name(user) do
    case user do
      %User{} -> user.name
      nil -> "guest"
    end
  end

  def get_username(user) do
    case user do
      %User{} -> user.username
      nil -> "guest"
    end
  end
end
