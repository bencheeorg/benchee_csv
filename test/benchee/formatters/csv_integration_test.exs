defmodule Benchee.Formatters.CSVIntegrationTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  @file_path "test.csv"
  test "works just fine" do
    capture_io fn ->
      Benchee.run %{
        time: 0.01,
        warmup: 0.02,
        formatters: [&Benchee.Formatters.CSV.output/1],
        csv: %{file: @file_path}
      },
      %{
        "Sleep"        => fn -> :timer.sleep(10) end,
        "Sleep longer" => fn -> :timer.sleep(20) end
      }

      assert File.exists?(@file_path)
      File.rm! @file_path
    end
  end
end
