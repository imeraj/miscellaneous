defmodule Webhooks.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    partitions =
      Application.get_env(:webhooks, :partitions, System.schedulers_online())

    children = [
      {PartitionSupervisor,
       child_spec: Task.Supervisor, name: Webhooks.TaskSupervisors, partitions: partitions},
      Webhooks.Manager
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Webhooks.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
