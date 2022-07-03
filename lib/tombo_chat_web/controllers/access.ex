defmodule TomboChatWeb.Access do
  import Plug.Conn
  import Phoenix.Controller
  alias TomboChatWeb.Router.Helpers, as: Routes

  def init(opts), do: opts

  def call(conn, _opts), do: conn

  def is_admin(%Plug.Conn{assigns: %{current_user: nil}} = _conn) do
    false
  end
  def is_admin(%Plug.Conn{assigns: %{current_user: current_user}} = _conn) do
    current_user.admin
  end

  def allow_only_admin(conn, _opts) do
    if is_admin(conn) do
      conn
    else
      conn
      |> put_flash(:error, "Administrator can only access. you can't.")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end
  end

end