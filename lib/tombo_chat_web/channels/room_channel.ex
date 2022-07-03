defmodule TomboChatWeb.RoomChannel do
  use TomboChatWeb, :channel

  # Clients can join topic on a channel.
  # return {:ok, socket} to authorize a join attempt
  # return {:error, socket} do deny
  def join("room:" <> room_id = topic, _params, socket) do
    send(self(), :after_join)
    # jsのjoin().receive()に返す値
    {
      :ok,
      %{message: "this message was sent from room_channel.ex"},
      socket
    }
  end

  def handle_info(:after_join, socket) do
    push(socket, "presence_state", TomboChatWeb.Presence.list(socket))
    {:ok, _} = TomboChatWeb.Presence.track(
      socket,
      socket.assigns.user_id,
      %{device: "browser"})
    {:noreply, socket}
  end

  def handle_in("new_message", payload, socket) do
    broadcast!(socket, "new_message", %{
      body: payload["body"],
      user: payload["user"]
    })

    {:reply, :ok, socket}
  end
end