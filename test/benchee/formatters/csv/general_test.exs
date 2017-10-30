defmodule Benchee.Formatters.CSV.GeneralTest do
  use ExUnit.Case
  alias Benchee.Formatters.CSV.General
  alias Benchee.{Benchmark.Scenario}

  doctest Benchee.Formatters.CSV.General

  test "Adds headers to scenarios" do
    headers = [["Name", "Input", "Iterations per Second", "Average",
              "Standard Deviation", "Standard Deviation Iterations Per Second",
              "Standard Deviation Ratio", "Median", "Minimum", "Maximum",
              "Sample Size"]]
    assert headers == General.add_headers([])
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
      run_times: [500]
    }

    csv = ["My Job", "Some Input", 2.0e3, 500.0, 200.0, 800.0, 0.4, 450.0, 200, 900, 8]

    assert csv == General.to_csv(scenario)
  end
end
