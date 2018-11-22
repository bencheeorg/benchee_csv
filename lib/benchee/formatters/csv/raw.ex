defmodule Benchee.Formatters.CSV.Raw do
  alias Benchee.Benchmark.Scenario

  @moduledoc """
    Functionality for converting Benchee scenarios to raw csv.
  """

  @doc """
    Adds headers to given measurements.

    ## Examples
        iex> alias Benchee.Benchmark.Scenario
        iex> no_input = Benchee.Benchmark.no_input()
        iex> scenarios = [
        ...>   %Scenario{name: "Foo", input_name: "list"},
        ...>   %Scenario{name: "Bar", input_name: no_input}        
        ...> ]  
        iex> Benchee.Formatters.CSV.Raw.add_headers([[100, 200], [101, 201]], scenarios)
        [["Foo with input list", "Bar"], [100, 200], [101, 201]]
  """
  def add_headers(measurements, scenarios) do
    headers =
      Enum.map(scenarios, fn scenario ->
        "#{scenario.name}#{input_part(scenario)}"
      end)

    [headers | measurements]
  end

  @no_input Benchee.Benchmark.no_input()
  defp input_part(%Scenario{input_name: nil}), do: ""
  defp input_part(%Scenario{input_name: @no_input}), do: ""
  defp input_part(%Scenario{input_name: name}), do: " with input #{name}"
end
