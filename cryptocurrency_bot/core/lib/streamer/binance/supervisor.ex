defmodule Streamer.Binance.Supervisor do
  use Supervisor

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def init(_init_arg) do
    children = [
      {Streamer.Binance.DynamicStreamerSupervisor, []},
      {Task,
       fn ->
         Streamer.Binance.DynamicStreamerSupervisor.autostart_workers()
       end}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
