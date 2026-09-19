defmodule Streamer.Repo.Migrations.CreateStreamer.Settings do
  use Ecto.Migration

  def change do
    create table(:streamer_settings, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:symbol, :text, null: false)
      add(:status, :text, default: "off", null: false)

      timestamps()
    end

    create(unique_index(:streamer_settings, [:symbol]))
  end
end
