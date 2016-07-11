defmodule Benchee.Formatters.CSV do

  @moduledoc """
  Functionality for converting Benchee benchmarking results to CSV so that
  they can be written to file and opened in a spreadsheet tool for graph
  generation for instance.

  The most basic use case is to configure it as one of the formatters to be
  used by `Benchee.run/2`.

      Benchee.run(
        %{
          formatters: [
            &Benchee.Formatters.CSV.output/1,
            &Benchee.Formatters.Console.output/1
          ],
          csv: %{file: "my.csv"}
        },
        %{
          "flat_map"    => fn -> Enum.flat_map(list, map_fun) end,
          "map.flatten" => fn -> list |> Enum.map(map_fun) |> List.flatten end
        })

  """

  @doc """
  Uses `Benchee.Formatters.CSV.format/1` to transform the statistics output to
  a CSV, but also already writes it to a file defined in the initial
  configuration under `%{csv: %{file: "my.csv"}}`
  """
  def output(suite = %{config: %{csv: %{file: file}} }) do
    file = File.open! file, [:write]
    suite
    |> format
    |> Enum.each(fn(row) -> IO.write(file, row) end)
    
    suite
  end
  def output(_suite) do
    raise "You need to specify a file to write the csv to in the configuration as %{csv: %{file: \"my.csv\"}}"
  end

  @column_descriptors ["Name", "Iterations per Second", "Average",
                       "Standard Deviation",
                       "Standard Deviation Iterations Per Second",
                       "Standard Deviation Ratio", "Median"]

  @doc """
  Transforms the statistical results `Benche.statistics` to be written
  somewhere, such as a file through `IO.write/2`.

  ## Examples

      iex> suite = %{statistics: %{"My Job" => %{average: 200.0, ips: 5000.0, std_dev: 20, std_dev_ratio: 0.1, std_dev_ips: 500, median: 190.0}}}
      iex> suite
      iex> |> Benchee.Formatters.CSV.format
      iex> |> Enum.take(2)
      ["Name,Iterations per Second,Average,Standard Deviation,Standard Deviation Iterations Per Second,Standard Deviation Ratio,Median\\r\\n",
       "My Job,5.0e3,200.0,20,500,0.1,190.0\\r\\n"]

  """
  def format(%{statistics: jobs}) do
    sorted = Benchee.Statistics.sort(jobs)
    [@column_descriptors | job_csvs(sorted)]
    |> CSV.encode
  end

  defp job_csvs(jobs) do
    Enum.map(jobs, &to_csv/1)
  end

  defp to_csv({name, %{ips:           ips,
                       average:       average,
                       std_dev:       std_dev,
                       std_dev_ips:   std_dev_ips,
                       std_dev_ratio: std_dev_ratio,
                       median:        median}}) do
    [name, ips, average, std_dev, std_dev_ips, std_dev_ratio, median]
  end
end
