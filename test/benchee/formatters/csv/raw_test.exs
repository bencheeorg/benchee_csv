defmodule Benchee.Formatters.CSV.RawTest do
  use ExUnit.Case
  alias Benchee.Formatters.CSV.Raw
  alias Benchee.{Benchmark.Scenario}

  doctest Benchee.Formatters.CSV.Raw

  test "Adds headers to scenarios" do
    headers = [
      ["Name", "Input", "Measurement1", "Measurement2", "Measurement3", "Measurement4", "Measurement5"],
      ["My Job", "Some Input", 500, 501, 502, 503, 504]
    ]
    assert headers == Raw.add_headers([["My Job", "Some Input", 500, 501, 502, 503, 504]])
  end

  test "Converts scenario to enumerable of statistics" do
    scenario = %Scenario{
      input_name: "Some Input",
      job_name: "My Job",
      run_times: [500, 501, 502, 503, 504]
    }

    csv = ["My Job", "Some Input", 500, 501, 502, 503, 504]

    assert csv == Raw.to_csv(scenario)
  end
end
