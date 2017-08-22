defmodule Benchee.Formatters.CSVTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  doctest Benchee.Formatters.CSV

  @filename "test.csv"
  test ".output returns the suite again unchanged" do
    suite = %Benchee.Suite{
      scenarios: [
        %Benchee.Benchmark.Scenario{
          job_name: "My Job",
          run_times: [500],
          input_name: "Some Input",
          input: "Some Input",
          run_time_statistics: %Benchee.Statistics{
            average:       500.0,
            ips:           2000.0,
            std_dev:       200.0,
            std_dev_ratio: 0.4,
            std_dev_ips:   800.0,
            median:        450.0,
            minimum:       200,
            maximum:       900,
            sample_size:   8
          }
        }
      ],
      configuration: %Benchee.Configuration{
        formatter_options: %{csv: %{file: @filename}}
      }
    }

    try do
      output = capture_io fn ->
        return = Benchee.Formatters.CSV.output(suite)
        assert return == suite
      end
      assert File.exists?(@filename)
      assert output =~ @filename

    after
      if File.exists?(@filename) do
        File.rm!(@filename)
      end
    end
  end
end
