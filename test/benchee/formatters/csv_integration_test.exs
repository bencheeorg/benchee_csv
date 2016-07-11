defmodule Benchee.Formatters.CSVIntegrationTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  @file_path "test.csv"
  test "works just fine" do
    try do
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

        [header, _row_1, _row_2] = @file_path
                                 |> File.stream!
                                 |> CSV.decode
                                 |> Enum.take(3)

        [first_header | _rest] = header
        assert first_header == "Name"
      end
    after
      File.rm! @file_path
    end
  end
end
