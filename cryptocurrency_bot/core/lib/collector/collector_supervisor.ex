defmodule Collector.DataWarehouse.CollectorSupervisor do
  use Supervisor

  alias Collector.DataWarehouse.Subscriber.DynamicSupervisor

  @registry :collector_workers

  def start_link(_args) do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_args) do
    children = [
      {Registry, [keys: :unique, name: @registry]},
      {DynamicSupervisor, []},
      {Task,
       fn ->
         DynamicSupervisor.autostart_workers()
       end}
    ]

    Supervisor.init(children, strategy: :rest_for_one)
  end
end
