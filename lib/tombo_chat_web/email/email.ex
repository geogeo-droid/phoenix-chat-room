defmodule TomboChatWeb.Email do
  use Bamboo.Phoenix, view: TomboChatWeb.EmailView

  alias TomboChat.Accounts.User

  def account_activation(%User{} = user) do
    base()
    |> subject("Your Account Activation Link")
    |> to(user.email)
    |> assign(:user, user)
    |> render(:account_activation)
  end

  defp base do
    new_email()
    |> from("Tombo Chat<noreply@tombochat.com>")
    |> put_html_layout({TomboChatWeb.LayoutView, "email.html"})
    |> put_text_layout({TomboChatWeb.LayoutView, "email.text"})
  end
end
