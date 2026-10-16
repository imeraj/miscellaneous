defmodule StripeClient.Adapter.HTTP do
  @behaviour StripeClient.Adapter

  require Logger

  @impl StripeClient.Adapter
  def create_customer(params) do
    Logger.debug("HTTP create_customer with params: #{inspect(params)}")

    :post
    |> :httpc.request(
      {url("/customers"), headers(), ~c"application/json", :json.encode(params)},
      [],
      []
    )
    |> handle_response()
  end

  @impl StripeClient.Adapter
  def delete_customer(id) do
    Logger.debug("HTTP delete_customer with ID: #{inspect(id)}")

    :delete
    |> :httpc.request({url("/customers/#{id}"), headers()}, [], [])
    |> handle_response()
  end

  # Private functions
  defp handle_response({:ok, {{_vsn, 200, _status}, _headers, body}}) do
    {:ok, body |> List.to_string() |> :json.decode()}
  end

  defp handle_response({:ok, {{_vsn, status, _status}, _headers, _body}}) do
    Logger.warning("Stripe API call failed: #{inspect(status)}")

    {:error, "Stripe API responded with #{status} status"}
  end

  defp url(endpoint) do
    ~c"https://api.stripe.com/v1#{endpoint}"
  end

  defp headers do
    auth_token =
      :stripe_client
      |> Application.fetch_env!(__MODULE__)
      |> Keyword.fetch!(:auth_token)

    [{~c"Authorization", ~c"Bearer #{auth_token}"}]
  end
end
