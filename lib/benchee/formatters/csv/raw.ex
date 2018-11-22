defmodule Benchee.Formatters.CSV.Raw do
  @moduledoc """
  Functionality for converting Benchee scenarios to raw csv.
  """

  alias Benchee.Benchmark.Scenario

  @doc false
  def add_headers(measurements, scenarios) do
    headers =
      Enum.flat_map(scenarios, fn scenario ->
        [
          "#{scenario.name}#{input_part(scenario)} (Run Time Measurements)",
          "#{scenario.name}#{input_part(scenario)} (Memory Usage Measurements)"
        ]
      end)

    [headers | measurements]
  end

  @doc false
  def to_csv(scenario), do: [scenario.run_times, scenario.memory_usages]

  @no_input Benchee.Benchmark.no_input()
  defp input_part(%Scenario{input_name: nil}), do: ""
  defp input_part(%Scenario{input_name: @no_input}), do: ""
  defp input_part(%Scenario{input_name: name}), do: " with input #{name}"
end
