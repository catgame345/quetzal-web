defmodule Periodistic.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :autor, :string
      add :email, :string
      add :texto, :text
      add :imagenes, :string
      add :enlaces, :string
      add :riesgo, :boolean, default: false, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
