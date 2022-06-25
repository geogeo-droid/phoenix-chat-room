defmodule TomboChatWeb.Auth do
  import Plug.Conn
  import Phoenix.Controller
  alias TomboChatWeb.Router.Helpers, as: Routes

  alias TomboChat.Accounts.User

  def init(opts), do: opts

  def call(conn, _opts) do
    # NOTE: ここがAuthの肝
    # このplugがrouterのpipeline browserにあることで
    # アクセス毎にconnにcurrent_userをassignできている。
    user_id = get_session(conn, :user_id)

    cond do
      user = conn.assigns[:current_user] ->
        # NOTE: 運用ではこのルートは通らない。テストをシンプルにするため。
        # see. Programming Phoenix Chapter 8, Preparing for Logged-In Users
        put_current_user(conn, user)

      user = user_id && TomboChat.Accounts.get_user(user_id) ->
        put_current_user(conn, user)

      true ->
        assign(conn, :current_user, nil)
    end
  end

  def login(conn, %User{} = user) do
    conn
    # NOTE: difference between assign and put_session
    # https://stackoverflow.com/questions/46502455/what-is-the-difference-between-assign-and-put-session-in-plug-conn-of-the-phoeni/46502682
    |> put_current_user(user)
    # puts the user ID in the session
    |> put_session(:user_id, user.id)
    # this protects us from session fixation attacks
    |> configure_session(renew: true)
  end

  defp put_current_user(conn, %User{} = user) do
    # TODO Phoenix.Tokenについて調べる
    token = Phoenix.Token.sign(conn, "user socket", user.id)

    conn
    # stores user as the :current_user in conn
    |> assign(:current_user, user)
    |> assign(:user_token, token)
  end

  def logout(conn) do
    # drop the whole session at the end of request
    configure_session(conn, drop: true)
  end

  # function plug receives
  # two arguments, the connection and a set of options
  # and returns the connection.
  def authenticate_user(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> redirect(to: Routes.session_path(conn, :new))
      |> halt()
    end
  end
end
