defmodule Benchee.Formatters.CSV.RawTest do
  use ExUnit.Case
  alias Benchee.Formatters.CSV.Raw
  alias Benchee.{Benchmark.Scenario}

  test "Adds headers to scenarios" do
    headers = [
      ["Name", "Input", "Measurement1", "Measurement2", "Measurement3", "Measurement4", "Measurement5"],
      ["My Job", "Some Input", 500, 501, 502, 503, 504]
    ]
    assert headers == Raw.add_headers([["My Job", "Some Input", 500, 501, 502, 503, 504]])
  end

  test "Converts scenario to enumerable of statistics" do
    scenario = %Scenario{
      after_each: nil,
      after_scenario: nil,
      before_each: nil,
      before_scenario: nil,
      function: nil,
      input: "Some Input",
      input_name: "Some Input",
      job_name: "My Job",
      memory_usage_statistics: nil,
      memory_usages: [],
      run_time_statistics: %Benchee.Statistics{
        average: 500.0,
        ips: 2.0e3,
        maximum: 900,
        median: 450.0,
        minimum: 200,
        mode: nil,
        percentiles: nil,
        sample_size: 8,
        std_dev: 200.0,
        std_dev_ips: 800.0,
        std_dev_ratio: 0.4
      },
      run_times: [500, 501, 502, 503, 504]
    }

    csv = ["My Job", "Some Input", 500, 501, 502, 503, 504]

    assert csv == Raw.to_csv(scenario)
  end
end
