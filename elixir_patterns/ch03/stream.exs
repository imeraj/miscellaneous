enum_time = fn upper_bound ->
  :timer.tc(fn ->
    1..upper_bound
    |> Enum.reject(&(rem(&1, 2) == 1))
    |> Enum.map(&(&1 * 2))
    |> Enum.sum()
  end)
end

stream_time = fn upper_bound ->
  :timer.tc(fn ->
    1..upper_bound
    |> Stream.reject(&(rem(&1, 2) == 1))
    |> Stream.map(&(&1 * 2))
    |> Enum.sum()
  end)
end

enum_time.(50) |> IO.inspect()
stream_time.(50) |> IO.inspect()

enum_time.(5000) |> IO.inspect()
stream_time.(5000) |> IO.inspect()

enum_time.(500_000) |> IO.inspect()
stream_time.(500_000) |> IO.inspect()

Mix.install([:req])

31_424_400
|> Stream.iterate(&(&1 + 1))
|> Enum.reduce_while([], fn
  _item, acc when length(acc) >= 3 ->
    {:halt, acc}

  item, acc ->
    "https://hacker-news.firebaseio.com/v0/item/#{item}.json"
    |> Req.get!()
    |> Map.get(:body)
    |> case do
      %{"type" => "comment", "text" => text} = data when is_binary(text) ->
        if String.contains?(String.downcase(text), "elixir") do
          {:cont, [data | acc]}
        else
          {:cont, acc}
        end

      _ ->
        {:cont, acc}
    end
end)
|> IO.inspect()
