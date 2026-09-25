defmodule MyCoolStack do
  use Agent

  def start(initial_elements \\ []) do
    Agent.start(fn -> initial_elements end, name: __MODULE__)
  end

  def stop do
    Agent.stop(__MODULE__)
  end

  def push(element) do
    Agent.update(__MODULE__, fn state -> [element | state] end)
  end

  def inspect do
    Agent.get(__MODULE__, fn state -> state end)
  end

  def pop do
    Agent.get_and_update(__MODULE__, fn
      [] ->
        {{:error, :empty_stack}, []}

      [head | rest] ->
        {head, rest}
    end)
  end
end

{:ok, _agent_pid} = MyCoolStack.start()

Process.whereis(MyCoolStack) |> Process.info() |> IO.inspect()

Enum.each(1..10, fn value -> MyCoolStack.push(value) end)

MyCoolStack.inspect() |> IO.inspect()

:sys.get_state(MyCoolStack) |> IO.inspect()

:sys.get_status(MyCoolStack) |> IO.inspect()

MyCoolStack.pop() |> IO.inspect()

MyCoolStack.pop() |> IO.inspect()

Process.list()
|> Enum.max_by(&Process.info(&1, :total_heap_size))
|> Process.info([:registered_name, :heap_size])
|> IO.inspect()

Process.list()
|> Enum.max_by(&Process.info(&1, :reductions))
|> Process.info([:registered_name, :reductions])
|> IO.inspect()
