defmodule TomboChat.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      # Ecto adds :id field automatically.

      add :username, :string, null: false
      add :name, :string
      add :password_hash, :string

      # timestamps() adds :inserted_at and :updated_at timestamp columns.
      # the type of 2 columns. Defaults to :native_datetime .
      timestamps()
    end

    # add a unique index to guarantee that
    # the username field is unique across the whole table.
    create unique_index(:users, [:username])
  end
end
