defmodule Benchee.Formatters.CSV.Raw do
  alias Benchee.Benchmark.Scenario

  @column_descriptors ["Name", "Input"]
  @moduledoc """
    Functionality for converting Benchee scenarios to raw csv.
  """

  @doc """
    Adds headers to given measurements.

    ## Examples
      iex> Benchee.Formatters.CSV.Raw.add_headers([["My Job", "Some Input", 500, 501, 502, 503, 504]], 5)
      [["Name", "Input", "Measurement1", "Measurement2", "Measurement3", "Measurement4", "Measurement5"],
      ["My Job", "Some Input", 500, 501, 502, 503, 504]]
  """
  def add_headers(measurements, sample_size) do
    [generate_heders_for_run_times(sample_size) | measurements]
  end

  @doc """
    Converts scenario to csv.

    ## Examples
      iex>scenario = %Benchee.Benchmark.Scenario {
      ...>  input_name: "Some Input",
      ...>  job_name: "My Job",
      ...>  run_times: [500, 501, 502, 503, 504]
      ...>}
      iex> Benchee.Formatters.CSV.Raw.to_csv(scenario)
      ["My Job", "Some Input", 500, 501, 502, 503, 504]
  """
  def to_csv(%Scenario{
                job_name: name,
                input_name: input_name,
                run_times: run_times}) do
    [name, input_name] ++ run_times
  end

  @doc """
    Get biggest sample_size from all passed in Benchee.Benchmark.Scenarios.

    ## Examples
      iex>scenarios = [%Benchee.Benchmark.Scenario{ run_time_statistics: %Benchee.Statistics{ sample_size: 4 }},
      ...>            %Benchee.Benchmark.Scenario{ run_time_statistics: %Benchee.Statistics{ sample_size: 14 }},
      ...>            %Benchee.Benchmark.Scenario{ run_time_statistics: %Benchee.Statistics{ sample_size: 1 }}]
      iex> Benchee.Formatters.CSV.Raw.get_biggest_sample_size(scenarios)
      14
  """
  def get_biggest_sample_size(scenarios) do
    biggest_scenario = scenarios
      |> Enum.max_by(fn(scenario) -> scenario.run_time_statistics.sample_size end)

    biggest_scenario.run_time_statistics.sample_size
  end

  defp generate_heders_for_run_times(sample_size) do
    header_for_measurements = (for n <- 0..(sample_size - 1), do: "Measurement#{n+1}")

    @column_descriptors ++ header_for_measurements
  end
end
