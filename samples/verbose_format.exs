# This will write raw and statistics into the same csv
file = File.open!("test.csv", [:write])
list = Enum.to_list(1..10_000)
map_fun = fn(i) -> [i, i * i] end

Benchee.init
|> Benchee.system
|> Benchee.benchmark("flat_map", fn -> Enum.flat_map(list, map_fun) end)
|> Benchee.benchmark("map.flatten",
                     fn -> list |> Enum.map(map_fun) |> List.flatten end)
|> Benchee.measure
|> Benchee.statistics
|> Benchee.Formatters.CSV.format(%{})
|> Tuple.to_list()
|> Enum.each(fn content ->
     Enum.each(content, fn(row) -> IO.write(file, row) end)
   end)
