list = Enum.to_list(1..10_000)
map_fun = fn i -> [i, i * i] end

[formatters: [{Benchee.Formatters.CSV, file: "my_verbose_output.csv"}]]
|> Benchee.init()
|> Benchee.system()
|> Benchee.benchmark("flat_map", fn -> Enum.flat_map(list, map_fun) end)
|> Benchee.benchmark(
  "map.flatten",
  fn -> list |> Enum.map(map_fun) |> List.flatten() end
)
|> Benchee.measure()
|> Benchee.statistics()
|> Benchee.Formatter.output()
