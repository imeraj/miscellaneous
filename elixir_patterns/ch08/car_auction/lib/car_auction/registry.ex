defmodule CarAuction.Registry do
  def child_spec(_opts) do
    Registry.child_spec(
      keys: :unique,
      name: __MODULE__
    )
  end

  def lookup(auction_id) do
    case Registry.lookup(__MODULE__, auction_id) do
      [{auction_id, _}] -> {:ok, auction_id}
      [] -> {:error, :not_found}
    end
  end
end
