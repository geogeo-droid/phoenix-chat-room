defmodule TomboChatWeb.Router do
  use TomboChatWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :fetch_live_flash
    # plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug TomboChatWeb.Auth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TomboChatWeb do
    pipe_through :browser

    get "/", PageController, :index

    resources "/users", UserController
    resources "/sessions", SessionController, only: [:new, :create, :delete]
    resources "/rooms", RoomController
  end

  # Other scopes may use custom stacks.
  # scope "/api", TomboChatWeb do
  #   pipe_through :api
  # end
end
