defmodule Naive.Schema.Setting do
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "settings" do
    field(:symbol, :string)
    field(:chunks, :integer)
    field(:budget, :decimal)
    field(:buy_down_interval, :decimal)
    field(:profit_target, :decimal)
    field(:rebuy_interval, :decimal)
    field(:status, Ecto.Enum, values: [:on, :off], default: :off)

    timestamps()
  end
end
