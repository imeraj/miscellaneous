defmodule Fresco.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table("products") do
      add :name, :string, null: false
      add :price, :string, null: false

      timestamps()
    end
  end
end
