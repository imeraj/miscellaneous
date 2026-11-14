defmodule Scraper.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Registry, keys: :unique, name: ProducerConsumerRegistry},
      Scraper.PageProducer,
      producer_consumer_spec(id: 1, partition: :a),
      producer_consumer_spec(id: 2, partition: :b),
      Scraper.PageConsumerSupervisor
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Scraper.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp producer_consumer_spec(id: id, partition: partition) do
    name = "online_page_producer_consumer_#{id}"

    %{
      id: name,
      start: {Scraper.OnlinePageProducerConsumer, :start_link, [name, partition]}
    }
  end
end
