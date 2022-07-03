defmodule TomboChat.SpacesTest do
  use TomboChat.DataCase, async: true

  alias TomboChat.Spaces

  describe "rooms" do
    alias TomboChat.Spaces.Room

    test "list_rooms/0 returns all rooms" do
      %Room{id: id1} = room_fixture(%{roomname: "a"})
      assert [%Room{id: ^id1}] = Spaces.list_rooms()
      %Room{id: id2} = room_fixture(%{roomname: "b"})
      assert [%Room{id: ^id1}, %Room{id: ^id2}] = Spaces.list_rooms()
    end

    # TODO: 他関数のテストを書く

  end
end