defmodule Collector.DataWarehouse.Schema.CollectorSetting do
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "collector_settings" do
    field(:topic, :string)
    field(:status, Ecto.Enum, values: [:off, :on], default: :off)

    timestamps()
  end
end
