unique_ets_table = :ets.new(:my_table, [:set])

user_1 = {1, %{first_name: "Alex", last_name: "Koutmos", favorite_lang: :elixir}}
user_2 = {2, %{first_name: "Hugo", last_name: "Barauna", favorite_lang: :elixir}}
user_3 = {3, %{first_name: "Joe", last_name: "Smith", favorite_lang: :go}}

:ets.insert(unique_ets_table, user_1)
:ets.insert(unique_ets_table, user_2)
:ets.insert(unique_ets_table, user_3)

:ets.lookup(unique_ets_table, 1) |> IO.inspect()
:ets.lookup(unique_ets_table, 2) |> IO.inspect()

:ets.lookup(unique_ets_table, 100) |> IO.inspect()

unique_ets_table
|> :ets.select([
  {
    {:"$1", %{first_name: :"$2", last_name: :"$3", favorite_lang: :elixir}},
    [],
    [{{:"$1", :"$2", :"$3"}}]
  }
])
|> IO.inspect()

unique_ets_table
|> :ets.select_count([
  {
    {:"$1", %{favorite_lang: :"$2"}},
    [{:==, :"$2", :elixir}],
    [true]
  }
])
|> IO.inspect()

unique_ets_table
|> :ets.select([
  {
    {:"$1", %{first_name: :"$2", last_name: :"$3", favorite_lang: :elixir}},
    [],
    [%{id: 1, first_name: :"$2", last_name: :"$3"}]
  }
])
|> IO.inspect()

# this part requires compiled program not script
select_fn =
  :ets.fun2ms(fn {id, %{first_name: first_name, last_name: last_name, favorite_lang: :elixir}} ->
    {id, first_name, last_name}
  end)

:ets.select(unique_ets_table, select_fn) |> IO.inspect()

select_fn =
  :ets.fun2ms(fn {_id, %{favorite_lang: lang}} when lang == :elixir ->
    true
  end)

:ets.select_count(unique_ets_table, select_fn) |> IO.inspect()

:ets.delete(unique_ets_table)
