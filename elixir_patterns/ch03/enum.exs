data = [
  %{name: "Ferrari Italia", type: :sports_car},
  %{name: "Honda Passport", type: :crossover},
  %{name: "Chevy Camaro", type: :sports_car},
  %{name: "Dodge Ram", type: :truck}
]

Enum.filter(data, fn
  %{type: :sports_car} -> true
  _ -> false
end)
|> IO.inspect()

Enum.reject(data, &match?(%{type: :sports_car}, &1)) |> IO.inspect()

Enum.filter(data, fn
  %{type: type} when type in [:crossover, :truck] -> true
  _ -> false
end)
|> IO.inspect()

data = [
  %{id: 1, name: "Alex"},
  %{id: 1, name: "Alexander"},
  %{id: 2, name: "Joe"},
  %{id: 3, name: "Jane"}
]

Enum.uniq_by(data, & &1.id) |> IO.inspect()

vehicle_inventory = [
  %{year: 1967, make: "Chevy", model: "Camaro"},
  %{year: 2020, make: "Lamborghini", model: "Huracan"},
  %{year: 1994, make: "Honda", model: "Civic"},
  %{year: 2000, make: "Honda", model: "Accord"},
  %{year: 2004, make: "Mitsubishi", model: "Evolution 8"},
  %{make: "Toyota", model: "Supra"},
  %{make: "Toyota", model: "MR2"},
  %{make: "Mazda", model: "RX-7"}
]

Enum.reduce(vehicle_inventory, MapSet.new(), fn %{make: make}, acc ->
  MapSet.put(acc, make)
end)
|> MapSet.to_list()
|> IO.inspect()

Enum.reduce_while(vehicle_inventory, MapSet.new(), fn
  %{year: year}, acc -> {:cont, MapSet.put(acc, year)}
  _, _ -> {:halt, {:error, :missing_year}}
end)
|> IO.inspect()
