defmodule Benchee.Formatters.CSV.Raw do
  alias Benchee.Benchmark.Scenario

  @column_descriptors ["Name", "Input"]
  @moduledoc """
    Functionality for converting Benchee scenarios to raw csv.
  """

  @doc """
    Adds headers to given scenarios.

    ## Examples
      iex> Benchee.Formatters.CSV.Raw.add_headers([["My Job", "Some Input", 500, 501, 502, 503, 504]])
      [["Name", "Input", "Measurement1", "Measurement2", "Measurement3", "Measurement4", "Measurement5"],["My Job", "Some Input", 500, 501, 502, 503, 504]]
  """
  def add_headers(scenarios) do
    [generate_heders_for_run_times(Enum.fetch!(scenarios, 0)) | scenarios]
  end

  def generate_heders_for_run_times(scenario) do
    headers_for_measurements = scenario
      |> Enum.drop(2)
      |> Enum.with_index()
      |> Enum.map(fn({_measurement, index}) -> "Measurement#{index+1}" end)

    Enum.concat(@column_descriptors, headers_for_measurements)
  end

  @doc """
    Converts scenario to csv.

    ## Examples
      iex> Benchee.Formatters.CSV.Raw.to_csv(%Scenario{input_name: "Some Input", job_name: "My Job", run_times: [500, 501, 502, 503, 504]})
      ["My Job", "Some Input", 500, 501, 502, 503, 504]
  """
  def to_csv(%Scenario{
                job_name: name,
                input_name: input_name,
                run_times: run_times}) do
    Enum.concat([name, input_name], run_times)
  end
end
