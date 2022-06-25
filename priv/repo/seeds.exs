# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     TomboChat.Repo.insert!(%TomboChat.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias TomboChat.Spaces
alias TomboChat.Accounts

{:ok, _} = Spaces.create_room(%{roomname: "lobby", name: "ロビー"})

{:ok, admin} =
  Accounts.register_admin_user(%{
    username: "administrator",
    name: "administrator",
    email: "admin@example.com",
    password: "administrator",
    admin: true
  })

admin |> IO.inspect() |> Accounts.activate()
