defmodule StripeClient do
  @moduledoc """
  Documentation for `StripeClient`.
  """

  @behaviour StripeClient.Adapter

  @adapter :stripe_client
  |> Application.compile_env!(__MODULE__)
  |> Keyword.fetch!(:adapter)

  @impl StripeClient.Adapter
  defdelegate create_customer(params), to: @adapter

  @impl StripeClient.Adapter
  defdelegate delete_customer(id), to: @adapter
end
