{:ok, my_dets_table} = :dets.open_file(~c'my_dets_table.dets', type: :bag)

my_ets_table = :ets.new(:my_metrics_table, [:bag])

:dets.to_ets(my_dets_table, my_ets_table)

:ets.tab2list(my_ets_table) |> IO.inspect()

:ets.insert(my_ets_table, {:auth_attempt, %{user: "Alex", ts: NaiveDateTime.utc_now()}})
:ets.insert(my_ets_table, {:auth_attempt, %{user: "Hugo", ts: NaiveDateTime.utc_now()}})

:ets.insert(
  my_ets_table,
  {:new_user_created, %{user: "Jane", ts: NaiveDateTime.utc_now()}}
)

:ets.to_dets(my_ets_table, my_dets_table)

:dets.info(my_dets_table) |> IO.inspect()

:dets.sync(my_dets_table)
