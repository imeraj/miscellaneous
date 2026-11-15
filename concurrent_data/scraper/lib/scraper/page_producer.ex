defmodule Scraper.PageProducer do
  use GenStage
  require Logger

  def start_link(_args) do
    initial_state = []
    GenStage.start_link(__MODULE__, initial_state)
  end

  def scrape_pages(pages) do
    ScrapingPipeline
    |> Broadway.producer_names()
    |> List.first()
    |> GenStage.cast({:pages, pages})
  end

  # callbacks
  @impl GenStage
  def init(initial_state) do
    Logger.info("PageProducer init")

    # Old partition dispatcher setup, kept for reference.
    # partitions = [:a, :b]
    #
    # hash = fn event ->
    #   {event, Enum.at(partitions, :erlang.phash2(event, length(partitions)))}
    # end
    #
    # opts = [
    #   partitions: partitions,
    #   hash: hash
    # ]
    #
    # {:producer, initial_state, dispatcher: {GenStage.PartitionDispatcher, opts}}

    # Use the DemandDispatcher supplied by Broadway.
    {:producer, initial_state}
  end

  @impl GenStage
  def handle_cast({:pages, pages}, state) do
    {:noreply, pages, state}
  end

  @impl GenStage
  def handle_demand(demand, state) do
    Logger.info("PageProducer received demand for #{demand} pages")

    events = []
    {:noreply, events, state}
  end
end
