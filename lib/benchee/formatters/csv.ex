defmodule Benchee.Formatters.CSV do
  use Benchee.Formatter

  alias Benchee.{Suite, Configuration}
  alias Benchee.Formatters.CSV.{General, Raw}

  @raw_benchmark_output "raw_benchmark_output.csv"
  @moduledoc """
  Functionality for converting Benchee benchmarking results to CSV so that
  they can be written to file and opened in a spreadsheet tool for graph
  generation for instance.

  The most basic use case is to configure it as one of the formatters to be
  used by `Benchee.run/2`.

      Benchee.run(
      %{
        "flat_map"    => fn -> Enum.flat_map(list, map_fun) end,
        "map.flatten" => fn -> list |> Enum.map(map_fun) |> List.flatten end
      },
        formatters: [
          &Benchee.Formatters.CSV.output/1,
          &Benchee.Formatters.Console.output/1
        ],
        formatter_options: [csv: %[file: "my.csv"]]
      )

  """

  @doc """
  Transforms the statistical results `Benche.statistics` to be written
  somewhere, such as a file through `IO.write/2`.

  ## Examples

      iex> suite = %Benchee.Suite{
      ...> 	scenarios: [
      ...> 		%Benchee.Benchmark.Scenario{
      ...> 			job_name: "My Job",
      ...> 			run_times: [500],
      ...> 			input_name: "Some Input",
      ...> 			input: "Some Input",
      ...> 			run_time_statistics: %Benchee.Statistics{
      ...> 				average:       500.0,
      ...> 				ips:           2000.0,
      ...> 				std_dev:       200.0,
      ...> 				std_dev_ratio: 0.4,
      ...> 				std_dev_ips:   800.0,
      ...> 				median:        450.0,
      ...> 				minimum:       200,
      ...> 				maximum:       900,
      ...> 				sample_size:   8
      ...> 			}
      ...> 		}
      ...> 	],
      ...> 	configuration: %Benchee.Configuration{
      ...> 		formatter_options: %{csv: %{file: "my_file.csv"}}
      ...> 	}
      ...> }
      iex> suite
      iex> |> Benchee.Formatters.CSV.format
      iex> |> Enum.fetch!(0)
      iex> |> (fn({rows, _}) -> Enum.take(rows, 2) end).()
      ["Name,Input,Iterations per Second,Average,Standard Deviation,Standard Deviation Iterations Per Second,Standard Deviation Ratio,Median,Minimum,Maximum,Sample Size\\r\\n",
       "My Job,Some Input,2.0e3,500.0,200.0,800.0,0.4,450.0,200,900,8\\r\\n"]

  """
  @spec format(Suite.t) :: [{Enumerable.t, String.t}]
  def format(%Suite{scenarios: scenarios, configuration: configuration}) do
    sorted_scenarios = Enum.sort_by(scenarios, fn(scenario) -> scenario.input_name end)

    [
      {get_general_benchmarks(sorted_scenarios), get_filename(configuration)},
      {get_raw_benchmarks(sorted_scenarios), @raw_benchmark_output}
    ]
  end

  defp get_general_benchmarks(scenarios), do: get_benchmarks(scenarios, &General.to_csv/1, &General.add_headers/1)
  defp get_raw_benchmarks(scenarios), do: get_benchmarks(scenarios, &Raw.to_csv/1, &Raw.add_headers/1)

  defp get_benchmarks(scenarios, to_csv, add_headers) do
    scenarios
           |> Enum.map(to_csv)
           |> add_headers.()
           |> CSV.encode()
  end

  @default_filename "benchmark_output.csv"
  defp get_filename(%Configuration{formatter_options: %{csv: %{file: filename}}}), do: filename
  defp get_filename(_configuration), do: @default_filename

  @doc """
  Uses the return value of `Benchee.Formatters.CSV.format/1` to write the
  statistics output to a CSV file, defined in the initial
  configuration under `[formatter_options: [csv: [file: \"my.csv\"]].
  If file is not defined then output is going to be placed in
  "benchmark_output.csv". All raw measurements are placed in raw_benchmark_output.csv.
  """
  @spec write([{Enumerable.t, String.t}]) :: :ok
  def write(benchmarks) do
    Enum.each(benchmarks, fn({content, filename}) -> write(content, filename) end)
  end

  defp write(content, filename) do
    File.open filename, [:write, :utf8], fn(file) ->
      Enum.each(content, fn(row) -> IO.write(file, row) end)
    end

    IO.puts "CSV written to #{filename}"
  end
end
