defmodule Benchee.Formatters.CSVTest do
  use ExUnit.Case
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
            median: 190.0
          }
        }
      }
    }

    try do
      return = Benchee.Formatters.CSV.output(suite)
      assert return == suite
    after
      File.rm! @filename
    end
  end
end
