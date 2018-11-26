defmodule Benchee.Formatters.CSV.Statistics do
  @moduledoc """
  Functionality for converting Benchee scenarios to csv with statistics.
  """

  alias Benchee.{Benchmark.Scenario, Statistics}

  @headers_without_memory [
    "Name",
    "Input",
    "Iterations per Second",
    "Standard Deviation Iterations Per Second",
    "Run Time Average",
    "Run Time Median",
    "Run Time Minimum",
    "Run Time Maximum",
    "Run Time Standard Deviation",
    "Run Time Standard Deviation Ratio",
    "Run Time Sample Size"
  ]
  @without_memory_length length(@headers_without_memory)

  @headers_with_memory @headers_without_memory ++
                         [
                           "Memory Usage Average",
                           "Memory Usage Median",
                           "Memory Usage Minimum",
                           "Memory Usage Maximum",
                           "Memory Usage Standard Deviation",
                           "Memory Usage Standard Deviation Ratio",
                           "Memory Usage Sample Size"
                         ]
  @with_memory_length length(@headers_with_memory)

  @doc false
  def add_headers([first_row | _] = measurements) do
    case length(first_row) do
      @without_memory_length -> [@headers_without_memory | measurements]
      @with_memory_length -> [@headers_with_memory | measurements]
    end
  end

  @doc false
  def to_csv(%Scenario{
        name: name,
        input_name: input_name,
        memory_usage_statistics: memory_usage_statistics,
        run_time_statistics: run_time_statistics
      }) do
    [name, input_name] ++
      to_csv(:run_time, run_time_statistics) ++ to_csv(:memory, memory_usage_statistics)
  end

  defp to_csv(:memory, %Statistics{
         average: average,
         std_dev: std_dev,
         std_dev_ratio: std_dev_ratio,
         median: median,
         minimum: minimum,
         maximum: maximum,
         sample_size: sample_size
       }) do
    [
      average,
      median,
      minimum,
      maximum,
      std_dev,
      std_dev_ratio,
      sample_size
    ]
  end

  defp to_csv(:memory, _), do: []

  defp to_csv(:run_time, %Statistics{
         ips: ips,
         average: average,
         std_dev: std_dev,
         std_dev_ips: std_dev_ips,
         std_dev_ratio: std_dev_ratio,
         median: median,
         minimum: minimum,
         maximum: maximum,
         sample_size: sample_size
       }) do
    [
      ips,
      std_dev_ips,
      average,
      median,
      minimum,
      maximum,
      std_dev,
      std_dev_ratio,
      sample_size
    ]
  end
end
