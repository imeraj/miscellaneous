defmodule Fresco.Application do
  # See https://elixir.hexdocs.pm/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      FrescoWeb.Telemetry,
      Fresco.Repo,
      {DNSCluster, query: Application.get_env(:fresco, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Fresco.PubSub},
      # Start a worker by calling: Fresco.Worker.start_link(arg)
      # {Fresco.Worker, arg},
      # Start to serve requests, typically the last entry
      FrescoWeb.Endpoint
    ]

    # See https://elixir.hexdocs.pm/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Fresco.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FrescoWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
