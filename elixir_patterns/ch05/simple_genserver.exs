defmodule SimpleGenServer do
  use GenServer

  def start_link(name) do
    GenServer.start_link(__MODULE__, name, name: name)
  end

  def child_spec(init_arg) do
    %{
      id: init_arg,
      start: {__MODULE__, :start_link, [init_arg]}
    }
  end

  @impl true
  def init(name) do
    Process.flag(:trap_exit, true)
    IO.puts("Starting GenServer: #{inspect(name)}")

    {:ok, name}
  end

  @impl true
  def terminate(_reason, name) do
    IO.puts("Shutting down GenServer: #{inspect(name)}")
    :ok
  end
end
