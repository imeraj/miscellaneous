defmodule Streamer.Schema.Setting do
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "settings" do
    field(:symbol, :string)
    field(:status, Ecto.Enum, values: [:on, :off], default: :off)

    timestamps()
  end
end
