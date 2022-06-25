defmodule TomboChatWeb.HelloLiveView do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <h1>Hello Live View</h1>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
