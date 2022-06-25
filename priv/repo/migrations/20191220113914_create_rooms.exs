defmodule TomboChat.Repo.Migrations.CreateRooms do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :roomname, :string, null: false
      add :name, :string

      timestamps()
    end

    create unique_index(:rooms, [:roomname])
  end
end
