defmodule SummerizerSupervisor do
  use Supervisor

  def start_link(init_args) do
    Supervisor.start_link(__MODULE__, init_args, name: __MODULE__)
  end

  @impl true
  def init(init_args) do
    children = [
      {EventCollector, init_args},
      {EventFlusher, init_args}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end

{:ok, pid} = SummerizerSupervisor.start_link(flush_interval: 1000)
Supervisor.which_children(pid)

test_users = [
  %User{id: "1", name: "MegaCorp", plan: :enterprise},
  %User{id: "2", name: "Gundam", plan: :basic},
  %User{id: "3", name: "CoffeeCentral", plan: :free},
  %User{id: "4", name: "CodeTogether", plan: :enterprise},
  %User{id: "5", name: "FPFunHouse", plan: :basic},
  %User{id: "6", name: "FPFunHouse", plan: :basic},
  %User{id: "7", name: "FPFunHouse", plan: :basic},
  %User{id: "8", name: "FPFunHouse", plan: :basic},
  %User{id: "9", name: "FPFunHouse", plan: :basic},
  %User{id: "10", name: "FPFunHouse", plan: :basic}
]

1..100_000
|> Task.async_stream(
  fn _ ->
    user = Enum.random(test_users)
    EventCollector.record_event(user)
  end,
  max_concurrency: 2000
)
|> Stream.run()

Supervisor.stop(pid)
