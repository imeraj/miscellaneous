defmodule Fresco.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset

  schema "accounts" do
    field :name, :string
    field :brand_colour, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:name, :brand_colour])
    |> validate_required([:name, :brand_colour])
    |> unique_constraint(:name)
  end
end
