defmodule TomboChatWeb.AdminSettingController do
  use TomboChatWeb, :controller
  plug :allow_only_admin

  def index(conn, params) do
    render(conn, "index.html")
  end
end
