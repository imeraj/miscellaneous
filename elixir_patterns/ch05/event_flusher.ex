defmodule EventFlusher do
  use GenServer

  require Logger

  # API
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  # Callbacks
  @impl true
  def init(opts) do
    state = %{
      flush_interval: Keyword.fetch!(opts, :flush_interval),
      partition: Keyword.fetch!(opts, :partition)
    }

    {:ok, state, {:continue, :schedule_next_run}}
  end

  @impl true
  def handle_continue(:schedule_next_run, state) do
    Process.send_after(self(), :flush_events, state.flush_interval)
    {:noreply, state}
  end

  @impl true
  def handle_info(:flush_events, state) do
    write_data_to_db = EventCollector.flush_events(state.partition)

    if map_size(write_data_to_db) > 0 do
      Logger.info(
        "#{__MODULE__}:#{inspect(state.partition)} - Flushed data: #{inspect(write_data_to_db)}"
      )
    end

    {:noreply, state, {:continue, :schedule_next_run}}
  end
end
