defmodule DataWarehouse.Subscriber.DynamicSupervisor do
  use DynamicSupervisor

  require Logger

  import Ecto.Query, only: [from: 2]

  alias DataWarehouse.Repo
  alias DataWarehouse.Schema.SubscriberSetting
  alias DataWarehouse.Subscriber.Worker

  @registry :subscriber_workers

  ## API
  def start_link(_arg) do
    DynamicSupervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def autostart_workers do
    Repo.all(from(s in SubscriberSetting, where: s.status == :on, select: s.topic))
    |> Enum.each(&start_child/1)
  end

  def start_worker(topic) do
    Logger.info("Starting storing data from #{topic} topic")
    update_status(topic, :on)
    start_child(topic)
  end

  def stop_worker(topic) do
    Logger.info("Stopping storing data from #{topic} topic")
    update_status(topic, :off)
    stop_child(topic)
  end

  ## Callbacks
  def init(_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  ## Private functions
  defp start_child(topic) do
    DynamicSupervisor.start_child(__MODULE__, {Worker, topic})
  end

  defp stop_child(topic) do
    case Registry.lookup(@registry, topic) do
      [{pid, _}] -> DynamicSupervisor.terminate_child(__MODULE__, pid)
      _ -> Logger.warning("Unable to locate process assigned to #{inspect(topic)}")
    end
  end

  defp update_status(topic, status)
       when is_binary(topic) and is_atom(status) do
    %SubscriberSetting{
      topic: topic,
      status: status
    }
    |> Repo.insert(
      on_conflict: :replace_all,
      conflict_target: :topic
    )
  end
end
