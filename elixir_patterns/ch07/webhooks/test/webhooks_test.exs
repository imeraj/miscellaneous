defmodule WebhooksTest do
  use ExUnit.Case
  doctest Webhooks

  test "greets the world" do
    assert Webhooks.hello() == :world
  end
end
