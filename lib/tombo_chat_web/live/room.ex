defmodule TomboChatWeb.Room do
  use Phoenix.LiveView
  use Phoenix.HTML

  import TomboChatWeb.ErrorHelpers, only: [error_tag: 2]

  alias TomboChat.Spaces
  alias TomboChat.Messages

  alias TomboChatWeb.Presence
  alias TomboChatWeb.Endpoint

  # render receive socket.assigns
  def render(assigns) do
    ~L"""
      <div class="columns">
        <div class="column is-10">
          <p class="title is-4">Messages@<%= @room.name %></p>
          <div id="messages" phx-update="append" phx-hook="RoomMessages" style="height: 360px; overflow: auto;">
            <%= for m <- @messages do %>
            <div id="message-<%= m.id %>" class="message" style="margin: 0em 0em 0.5em 0em;">
            <div class="message-body">
              <p><span>@<%= m.user.name %>: <%= m.body %></span></p>
              <p style="float: right;">
                <time datetime="<%= shift_naive_datetime(m.inserted_at) %>"><%= shift_naive_datetime(m.inserted_at) %></time>
              </p>
            </div>
            </div>
            <% end %>
          </div>
          <div>
            <%= form_for @message_changeset, "#", [phx_submit: :submit], fn f -> %>
              <%= textarea f, :body, placeholder: "Enter Message", class: "textarea", rows: "1" %>
              <%= error_tag f, :body %>
              <%= submit "Submit", class: "button is-success", style: "float: right;" %>
            <% end %>
          </div>
        </div>
        <div class="column is-2">
          <p class="title is-4">Members</p>
          <hr>
          <div class="list">
            <%= for user <- @users do %>
              <p class="list-item">
                @<%= user.name %>(<%= user.count %>)
              </p>
            <% end %>
          </div>
        </div>
      </div>
    """
  end

  defp topic(room_id), do: "room:#{room_id}"
  defp list_presence(topic) do
    Presence.list(topic)
    |> Enum.map(
         fn {_user_id, %{metas: list, user: user} = _data} ->
           %{name: user.name, count: Enum.count(list)}
         end
       )
  end

  def shift_naive_datetime(%NaiveDateTime{} = datetime) do
    datetime
    |> NaiveDateTime.add(3600*9)
    |> NaiveDateTime.to_string()
  end

  def mount(
        _params,
        %{"room" => room, "current_user" => current_user} = _session,
        socket) do
    TomboChatWeb.Endpoint.subscribe(topic(room.id))
    {:ok, _ref} = Presence.track(
      self(),          # pid
      topic(room.id),  # topic
      current_user.id, # key: tracked presences are grouped by key, cast as a string
      %{}              # meta
    )

    {:ok,
      assign(socket,
        room: room,
        current_user: current_user,
        message_changeset: Messages.change_message(),
        messages: Messages.list_messages(room),
        users: list_presence(topic(room.id))
      ),
      temporary_assigns: [messages: []]}
  end

  # presenceに変化があると発行されるメッセージ("presence_diff")のコールバック
  def handle_info(
        %{event: "presence_diff"},
        %{assigns: %{room: room}} = socket) do
    {:noreply, assign(socket, users: list_presence(topic(room.id)))}
  end

  def handle_info(
        %{event: "new_message", payload: new_message,
          topic: _}, socket) do
    socket = assign(socket, messages: [new_message])
    {:noreply, socket}
  end

  def handle_event(
        "submit",
        %{"message" => message} = _payload,
        %{assigns: %{room: room, current_user: current_user}} = socket) do

    case Messages.create_message(room.id, current_user.id, message) do
      {:ok, message} ->
        Endpoint.broadcast!(
          topic(room.id), "new_message", Messages.preload(message, :user))
        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, message_changeset: changeset)}
    end
  end

end
