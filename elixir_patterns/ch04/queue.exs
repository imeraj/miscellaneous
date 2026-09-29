defmodule MyApp.Queue do
  use GenServer, restart: :transient

  # Client API
  def start_link(initial_elements, name \\ __MODULE__) when is_list(initial_elements) do
    GenServer.start_link(__MODULE__, initial_elements, name: name)
  end

  def len(instance \\ __MODULE__) do
    GenServer.call(instance, :len)
  end

  def push(instance \\ __MODULE__, element) do
    GenServer.cast(instance, {:push, element})
  end

  def pop(instance \\ __MODULE__) do
    GenServer.call(instance, :pop)
  end

  # Server callbacks
  @impl GenServer
  def init(initial_elements) do
    state = %{
      queue: :queue.from_list(initial_elements),
      len: length(initial_elements)
    }

    {:ok, state}
  end

  @impl GenServer
  def handle_call(:len, _from, %{len: len} = state) do
    {:reply, len, state}
  end

  def handle_call(:pop, _from, %{queue: queue, len: len}) do
    {updated_queue, updated_len, element} =
      case :queue.out(queue) do
        {:empty, queue} -> {queue, 0, :empty}
        {{:value, value}, queue} -> {queue, len - 1, value}
      end

    {:reply, element, %{queue: updated_queue, len: updated_len}}
  end

  @impl GenServer
  def handle_cast({:push, element}, %{queue: queue, len: len}) do
    updated_state = %{
      queue: :queue.in(element, queue),
      len: len + 1
    }

    {:noreply, updated_state}
  end
end

MyApp.Queue.start_link([1, 2, 3])
MyApp.Queue.len() |> IO.inspect()

for idx <- 4..6, do: MyApp.Queue.push(idx)
MyApp.Queue.len() |> IO.inspect()

:sys.get_state(MyApp.Queue) |> IO.inspect()

for _idx <- 1..10, do: MyApp.Queue.pop() |> IO.inspect()

GenServer.stop(MyApp.Queue)
