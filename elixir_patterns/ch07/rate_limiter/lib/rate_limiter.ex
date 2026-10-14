defmodule RateLimiter do
  def run do
    rate_limiters = [
      stripe: [requests_per_second: 60],
      shopify: [requests_per_second: 30],
      twilio: [requests_per_second: 120],
      slow_api: [requests_per_second: 1]
    ]

    Enum.each(rate_limiters, fn {id, opts} ->
      RateLimiter.DynamicSupervisor.spawn_rate_limiter(id, opts)
    end)

    Enum.map([:stripe, :shopify, :twilio, :slow_api], fn rate_limiter ->
      {:ok, pid} = RateLimiter.Registry.lookup(rate_limiter)
      pid
    end)

    Enum.each(1..10, fn num ->
      IO.puts("Request #{num}")

      Task.async(fn ->
        RateLimiter.LeakyBucket.wait_for_turn(:slow_api)
        time = Time.truncate(Time.utc_now(), :second)
        IO.puts("[#{time}] Serviced request(:slow_api) - #{num}")
      end)
    end)

    Enum.each(1..10, fn num ->
      IO.puts("Request #{num}")

      Task.async(fn ->
        RateLimiter.LeakyBucket.wait_for_turn(:stripe)
        time = Time.truncate(Time.utc_now(), :second)
        IO.puts("[#{time}] Serviced reques(:stripe) - #{num}")
      end)
    end)
  end
end
