defmodule Benchee.Formatters.CSV do

  alias Benchee.{Suite, Configuration, Statistics, Benchmark.Scenario}

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
  Uses `Benchee.Formatters.CSV.format/1` to transform the statistics output to
  a CSV, but also already writes it to a file defined in the initial
  configuration under `[formatter_options: [csv: [file: \"my.csv\"]]`
  """
  @spec output(Suite.t) :: Suite.t
  def output(suite)
  def output(suite = %Suite{configuration:
              %Configuration{formatter_options: %{csv: %{file: filename}}}}) do
    suite
    |> format
    |> write_csv_to_file(filename)

    suite
  end
  def output(_suite) do
    raise "You need to specify a file to write the csv to in the configuration as [formatter_options: [csv: [file: \"my.csv\"]]"
  end

  defp write_csv_to_file(input_to_content, filename) do
    Benchee.Utility.FileCreation.each input_to_content,
                                    filename,
                                    fn(file, csv_list, filename) ->
      Enum.each(csv_list, fn(row) -> IO.write(file, row) end)
      IO.puts "CSV written to #{filename}"
    end
  end

  @column_descriptors ["Name", "Iterations per Second", "Average",
                       "Standard Deviation",
                       "Standard Deviation Iterations Per Second",
                       "Standard Deviation Ratio", "Median", "Minimum",
                       "Maximum", "Sample Size"]

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
      iex> |> Map.get("Some Input")
      iex> |> Enum.take(2)
      ["Name,Iterations per Second,Average,Standard Deviation,Standard Deviation Iterations Per Second,Standard Deviation Ratio,Median,Minimum,Maximum,Sample Size\\r\\n",
       "My Job,2.0e3,500.0,200.0,800.0,0.4,450.0,200,900,8\\r\\n"]

  """
  @spec format(Suite.t) :: %{Suite.key => String.t}
  def format(%Suite{scenarios: scenarios}) do
    scenarios
    |> Enum.group_by(fn(scenario) -> scenario.input_name end)
    |> Enum.map(&data_for_input/1)
    |> Map.new
  end

  defp data_for_input({input_key, scenarios}) do
    output = scenarios
             |> Benchee.Statistics.sort()
             |> Enum.map(&to_csv/1)
    {input_key, CSV.encode([@column_descriptors | output])}
  end

  defp to_csv(%Scenario{job_name: name, run_time_statistics:
                          %Statistics{ips:           ips,
                                      average:       average,
                                      std_dev:       std_dev,
                                      std_dev_ips:   std_dev_ips,
                                      std_dev_ratio: std_dev_ratio,
                                      median:        median,
                                      minimum:       minimum,
                                      maximum:       maximum,
                                      sample_size:   sample_size}}) do
    [name, ips, average, std_dev, std_dev_ips, std_dev_ratio, median, minimum,
    maximum, sample_size]
  end
end
