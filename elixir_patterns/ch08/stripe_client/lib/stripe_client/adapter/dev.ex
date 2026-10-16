defmodule StripeClient.Adapter.Dev do
  @behaviour StripeClient.Adapter

  require Logger

  @impl StripeClient.Adapter
  def create_customer(params) do
    Logger.debug("DEV create_customer with params: #{inspect(params)}")

    {:ok, %{"id" => "cus_123", "object" => "customer"}}
  end

  @impl StripeClient.Adapter
  def delete_customer(id) do
    Logger.debug("DEV delete_customer with ID: #{inspect(id)}")

    :ok
  end
end
