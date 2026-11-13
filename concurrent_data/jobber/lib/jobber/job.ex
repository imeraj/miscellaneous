defmodule Jobber.Job do
  use GenServer, restart: :transient

  require Logger

  defstruct [
    :work,
    :id,
    :max_retries,
    retries: 0,
    status: :new
  ]

  def start_link(args) do
    args =
      if Keyword.has_key?(args, :id) do
        args
      else
        Keyword.put(args, :id, random_job_id())
      end

    id = Keyword.get(args, :id)
    type = Keyword.get(args, :type)

    GenServer.start_link(__MODULE__, args, name: via(id, type))
  end

  # Callbacks
  @impl GenServer
  def init(args) do
    work = Keyword.fetch!(args, :work)
    id = Keyword.get(args, :id)
    max_retries = Keyword.get(args, :max_retries, 3)

    state = %Jobber.Job{
      work: work,
      id: id,
      max_retries: max_retries
    }

    {:ok, state, {:continue, :run}}
  end

  @impl GenServer
  def handle_continue(:run, state) do
    new_state = state.work.() |> handle_job_result(state)

    cond do
      new_state.status == :errored ->
        Process.send_after(self(), :retry, 5_000)
        {:noreply, new_state}

      new_state.status == :done ->
        Logger.info("Job exiting #{state.id}")
        {:stop, :normal, new_state}

      new_state.status == :failed ->
        Logger.error("Job failed permanently #{state.id}")
        {:stop, :normal, new_state}
    end
  end

  @impl GenServer
  def handle_info(:retry, %Jobber.Job{status: :errored} = state) do
    {:noreply, state, {:continue, :run}}
  end

  @impl GenServer
  def handle_info(:retry, state) do
    {:noreply, state}
  end

  # Private functions
  defp handle_job_result({:ok, _data}, %Jobber.Job{} = state) do
    Logger.info("Job completed #{state.id}")
    %{state | status: :done}
  end

  defp handle_job_result(:error, %Jobber.Job{status: :new} = state) do
    Logger.warning("Job errored #{state.id}")
    %{state | status: :errored}
  end

  defp handle_job_result(:error, %Jobber.Job{status: :errored} = state) do
    Logger.warning("Job retry failed #{state.id}")

    new_state = %{state | retries: state.retries + 1}

    if new_state.retries >= new_state.max_retries do
      %{new_state | status: :failed}
    else
      new_state
    end
  end

  defp random_job_id do
    :crypto.strong_rand_bytes(5)
    |> Base.url_encode64(padding: false)
  end

  defp via(key, value) do
    {:via, Registry, {Jobber.JobRegistry, key, value}}
  end
end
