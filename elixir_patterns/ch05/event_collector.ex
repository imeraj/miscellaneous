defmodule EventCollector do
  use GenServer

  require Logger

  # API
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  def record_event(%User{} = user) do
    user.id
    |> via_tuple()
    |> GenServer.cast({:record_event, user})
  end

  def flush_events(partition) do
    partition
    |> via_tuple()
    |> GenServer.call(:flush_events)
  end

  # Callbacks
  @impl true
  def init(_) do
    {:ok, %{count: 0, data: %{}}}
  end

  @impl true
  def handle_cast({:record_event, %User{} = user}, %{count: count, data: data}) do
    data = Map.update(data, user.id, 1, &(&1 + 1))
    {:noreply, %{count: count + 1, data: data}}
  end

  @impl true
  def handle_call(:flush_events, _from, %{count: count, data: data}) do
    if count > 0 do
      Logger.info("#{__MODULE__}:#{inspect(self())} - #{count} events flushed")
    end

    {:reply, data, %{count: 0, data: %{}}}
  end

  # Helpers
  def via_tuple(term) do
    {:via, PartitionSupervisor, {EventCollectorPartitionSupervisor, term}}
  end
end
