defmodule TomboChatWeb.UserView do
  use TomboChatWeb, :view

  def link_user(conn, user) do
    link(user.name, to: Routes.user_path(conn, :show, user.id))
  end

  def link_edit(conn, user, user) do
    link("Edit ", to: Routes.user_path(conn, :edit, user.id))
  end

  def link_edit(conn, user, _) do
    if is_admin(conn) do
      link("Edit ", to: Routes.user_path(conn, :edit, user.id))
    end
  end

  def link_delete(conn, user) do
    if is_admin(conn) do
      link("Delete ",
        to: Routes.user_path(conn, :delete, user),
        method: "delete",
        data: [confirm: "Are you sure?"]
      )
    end
  end
end
