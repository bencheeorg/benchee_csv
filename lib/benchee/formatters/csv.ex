defmodule Benchee.Formatters.CSV do
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
          {Benchee.Formatters.CSV, file: "my.csv"},
          Benchee.Formatters.Console
        ]
      )

  """
  @behaviour Benchee.Formatter

  alias Benchee.Formatters.CSV.{Statistics, Raw, Util}
  alias Benchee.Suite
  alias Benchee.Utility.FileCreation

  @doc """
  Transforms the statistical results `Benche.statistics` to be written
  somewhere, such as a file through `IO.write/2`.

  ## Examples

      iex> suite = %Benchee.Suite{
      ...> 	scenarios: [
      ...> 		%Benchee.Benchmark.Scenario{
      ...> 			name: "My Job",
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
      ...> 	]
      ...> }
      iex> suite
      iex> |> Benchee.Formatters.CSV.format(%{})
      iex> |> elem(0)
      iex> |> (fn rows -> Enum.take(rows, 2) end).()
      ["Name,Input,Iterations per Second,Average,Standard Deviation,Standard Deviation Iterations Per Second,Standard Deviation Ratio,Median,Minimum,Maximum,Sample Size\\r\\n",
       "My Job,Some Input,2.0e3,500.0,200.0,800.0,0.4,450.0,200,900,8\\r\\n"]

  """
  @spec format(Suite.t(), any) :: {Enumerable.t(), Enumerable.t()}
  def format(%Suite{scenarios: scenarios}, _) do
    sorted_scenarios = Enum.sort_by(scenarios, fn scenario -> scenario.input_name end)

    {get_benchmarks_statistics(sorted_scenarios), get_benchmarks_raw(sorted_scenarios)}
  end

  defp get_benchmarks_statistics(scenarios) do
    scenarios
    |> Enum.map(&Statistics.to_csv/1)
    |> Statistics.add_headers()
    |> CSV.encode()
  end

  defp get_benchmarks_raw(scenarios) do
    scenarios
    |> Enum.map(fn scenario -> scenario.run_times end)
    |> Util.zip_all()
    |> Raw.add_headers(scenarios)
    |> CSV.encode()
  end

  @doc """
  Uses the return value of `Benchee.Formatters.CSV.format/2` to write the
  statistics output to a CSV file, defined in the initial
  configuration. The raw measurements are placed in a file with "raw_" prepended
  onto the file name given in the initial configuration.

  If no file name is given in the configuration, "benchmark_output.csv" is used
  as a default.
  """
  @spec write({Enumerable.t(), Enumerable.t()}, map | nil) :: :ok
  def write({statistics, raw_measurements}, options) do
    filename = Map.get(options, :file, "benchmark_output.csv")
    write(statistics, filename, "statistics")
    write(raw_measurements, FileCreation.interleave(filename, "raw"), "raw measurements")
  end

  defp write(content, filename, type) do
    File.open(filename, [:write, :utf8], fn file ->
      Enum.each(content, fn row -> IO.write(file, row) end)
    end)

    IO.puts("#{type} CSV written to #{filename}")
  end
end
