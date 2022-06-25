defmodule TomboChatWeb.Rooms do
  use Phoenix.LiveView
  use Phoenix.HTML

  alias TomboChat.Spaces

  def render(assigns) do
    ~L"""
    <div class="columns">
      <div class="column is-2">
      <p class="title is-4">Rooms</p>
      <hr>
      <ul class="menu-list">
        <%= for room <- @rooms do %>
          <li phx-click="room_id_<%= room.id %>">
            <%= room_name_tag(@room, room) %>
          </li>
        <% end %>
      </ul>
      </div>
      <div class="column is-10">
        <%= render_room(@socket, @room) %>
      </div>
    </div>
    """
  end

  defp room_name_tag(room, room), do: content_tag(:a, "# #{room.name}", class: "is-active")
  defp room_name_tag(_, room), do: content_tag(:a, "# #{room.name}")

  defp render_room(socket, room) do
    # NOTE: live_renderはidを変更しないと再マウントしない
    live_render(socket, TomboChatWeb.Room,
      id: room.id,
      session: %{"room" => room, "current_user" => socket.assigns.current_user}
    )
  end

  def mount(_params, session, socket) do
    {:ok,
     assign(socket,
       rooms: Spaces.list_rooms(),
       room: Spaces.get_room_by(%{roomname: "lobby"}),
       current_user: session["current_user"]
     )}
  end

  def handle_event("room_id_" <> id, _params, %{assigns: _assigns} = socket) do
    {:noreply, assign(socket, room: Spaces.get_room(String.to_integer(id)))}
  end
end
