defmodule Benchee.Formatters.CSV.Statistics do
  alias Benchee.{Statistics, Benchmark.Scenario}

  @column_descriptors ["Name", "Input", "Iterations per Second", "Average",
                       "Standard Deviation",
                       "Standard Deviation Iterations Per Second",
                       "Standard Deviation Ratio", "Median", "Minimum",
                       "Maximum", "Sample Size"]
  @moduledoc """
    Functionality for converting Benchee scenarios to csv with statistics.
  """

  @doc """
    Adds headers to given measurements.

    ## Examples
      iex> Benchee.Formatters.CSV.Statistics.add_headers([])
      [["Name", "Input", "Iterations per Second", "Average", "Standard Deviation",
      "Standard Deviation Iterations Per Second", "Standard Deviation Ratio",
      "Median", "Minimum", "Maximum", "Sample Size"]]
  """
  def add_headers(measurements) do
    [@column_descriptors | measurements]
  end

  @doc """
    Converts scenario to csv.

    ## Examples
      iex> Benchee.Formatters.CSV.Statistics.to_csv(%Benchee.Benchmark.Scenario{
      ...>  input_name: "Some Input",
      ...>  name: "My Job",
      ...>  run_time_statistics: %Benchee.Statistics{
      ...>    average: 500.0,
      ...>    ips: 2.0e3,
      ...>    maximum: 900,
      ...>    median: 450.0,
      ...>    minimum: 200,
      ...>    mode: nil,
      ...>    percentiles: nil,
      ...>    sample_size: 8,
      ...>    std_dev: 200.0,
      ...>    std_dev_ips: 800.0,
      ...>    std_dev_ratio: 0.4
      ...>  }
      ...>})
      ["My Job", "Some Input", 2.0e3, 500.0, 200.0, 800.0, 0.4, 450.0, 200, 900, 8]
  """
  def to_csv(%Scenario{
                name: name,
                input_name: input_name,
                run_time_statistics: %Statistics{
                                       ips:           ips,
                                       average:       average,
                                       std_dev:       std_dev,
                                       std_dev_ips:   std_dev_ips,
                                       std_dev_ratio: std_dev_ratio,
                                       median:        median,
                                       minimum:       minimum,
                                       maximum:       maximum,
                                       sample_size:   sample_size}}) do
    [name, input_name, ips, average, std_dev, std_dev_ips, std_dev_ratio,
     median, minimum, maximum, sample_size]
  end
end
