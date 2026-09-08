defmodule DataWarehouse.Schema.SubscriberSetting do
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "subscriber_settings" do
    field(:topic, :string)
    field(:status, Ecto.Enum, values: [:off, :on], default: :off)

    timestamps()
  end
end
