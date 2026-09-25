{time, results} =
  :timer.tc(fn ->
    1..10
    |> Enum.map(fn _ ->
      Task.async(fn -> Process.sleep(1_500) end)
    end)
    |> Task.await_many()
  end)

IO.inspect(results)

System.convert_time_unit(time, :microsecond, :millisecond) |> IO.inspect()

task =
  Task.async(fn ->
    Process.sleep(1_000)
    :all_good
  end)

Task.yield(task, 500) |> IO.inspect()

Task.yield(task, 1000) |> IO.inspect()

Task.async(fn ->
  Process.sleep(1_000)
end)
|> Task.await(500)
