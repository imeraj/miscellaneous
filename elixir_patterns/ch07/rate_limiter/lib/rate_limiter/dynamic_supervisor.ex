defmodule RateLimiter.DynamicSupervisor do
  use DynamicSupervisor

  def start_link(opts) do
    DynamicSupervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def spawn_rate_limiter(id, opts) do
    child_spec = %{
      id: RateLimiter.LeakyBucket,
      start: {RateLimiter.LeakyBucket, :start_link, [id, opts]},
      restart: :transient
    }

    {:ok, _pid} =
      DynamicSupervisor.start_child(
        __MODULE__,
        child_spec
      )
  end

  # Callbacks
  def init(_opts) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
