defmodule Jobber.JobSupervisor do
  use Supervisor, restart: :temporary

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args)
  end

  @impl Supervisor
  def init(args) do
    children = [
      {Jobber.Job, args}
    ]

    opts = [
      strategy: :one_for_one,
      max_seconds: 30
    ]

    Supervisor.init(children, opts)
  end
end
