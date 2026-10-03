defmodule ParentSupervisor do
  use Supervisor

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def init(_init_arg) do
    IO.puts("Starting Supervisor: #{inspect(__MODULE__)}")

    children = [
      {SimpleGenServer, :gen_server_one},
      {ChildSupervisor, []},
      {SimpleGenServer, :gen_server_four}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end

ParentSupervisor.start_link([])
Supervisor.stop(ParentSupervisor)

GenServer.stop(:gen_server_two, :brutal_kill)
GenServer.stop(:gen_server_one, :brutal_kill)
GenServer.stop(ChildSupervisor, :brutal_kill)
