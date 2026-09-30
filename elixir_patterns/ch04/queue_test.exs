ExUnit.start()

defmodule MyApp.QueueTest do
  use ExUnit.Case, async: true

  describe "MyApp.Queue" do
    setup %{module: module, test: test} do
      queue_name = Module.concat([module, test, Queue])

      child_spec = %{
        id: MyApp.Queue,
        restart: :transient,
        start: {MyApp.Queue, :start_link, [[], queue_name]}
      }

      start_supervised!(child_spec)

      [queue_name: queue_name]
    end

    test "should return first element in the queue", %{queue_name: queue_name} do
      MyApp.Queue.push(queue_name, 1)
      MyApp.Queue.push(queue_name, 2)

      value = MyApp.Queue.pop(queue_name)

      assert value == 1
      refute Process.whereis(MyApp.Queue)
    end
  end
end
