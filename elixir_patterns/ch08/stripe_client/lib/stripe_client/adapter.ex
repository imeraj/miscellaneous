defmodule StripeClient.Adapter do
  @doc "Create a stripe customer"
  @callback create_customer(params :: map()) ::
              {:ok, customer :: map()} | {:error, reason :: String.t()}

  @doc "Delete a customer in Stripe"
  @callback(delete_customer(id :: String.t()) :: :ok, {:error, reason :: String.t()})
end
