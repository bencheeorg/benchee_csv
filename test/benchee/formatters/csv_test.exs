defmodule Benchee.Formatters.CSVTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  doctest Benchee.Formatters.CSV

  @filename "test.csv"
  test ".output returns the suite again unchanged" do
    suite = %{
      config: %{
        csv: %{file: @filename}
        },
      statistics: %{
        "Some Input" => %{
          "My Job" => %{
            average: 200.0,
            ips: 5000.0,
            std_dev: 20,
            std_dev_ratio: 0.1,
            std_dev_ips: 500,
            median: 190.0,
            minimum: 180,
            maximum: 250,
            sample_size: 345
          }
        }
      }
    }

    try do
      output = capture_io fn ->
        return = Benchee.Formatters.CSV.output(suite)
        assert return == suite
      end
      assert File.exists?("test_some_input.csv")
      assert output =~ "test_some_input.csv"

    after
      if File.exists?("test_some_input.csv") do
        File.rm!("test_some_input.csv")
      end
    end
  end
end
