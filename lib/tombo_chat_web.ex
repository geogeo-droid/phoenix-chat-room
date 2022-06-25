defmodule TomboChatWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use TomboChatWeb, :controller
      use TomboChatWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: TomboChatWeb

      import Plug.Conn
      import TomboChatWeb.Gettext
      import Phoenix.LiveView.Controller
      import TomboChatWeb.Auth, only: [authenticate_user: 2]
      import TomboChatWeb.Access, only: [allow_only_admin: 2]
      alias TomboChatWeb.Router.Helpers, as: Routes
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/tombo_chat_web/templates",
        namespace: TomboChatWeb

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_flash: 1, get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import TomboChatWeb.ErrorHelpers
      import TomboChatWeb.Gettext

      import Phoenix.LiveView.Helpers

      import TomboChatWeb.Access, only: [is_admin: 1]
      alias TomboChatWeb.Router.Helpers, as: Routes
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
      import TomboChatWeb.Auth, only: [authenticate_user: 2]
      import TomboChatWeb.Access, only: [allow_only_admin: 2]
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import TomboChatWeb.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
