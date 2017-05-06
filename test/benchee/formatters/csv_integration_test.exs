defmodule Benchee.Formatters.CSVIntegrationTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  @file_path "test.csv"
  test "works just fine" do
    basic_test(time: 0.01,
               warmup: 0.02,
               formatters: [&Benchee.Formatters.CSV.output/1],
               formatter_options: [csv: [file: @file_path]])
  end

  test "old school configuration still works" do
    basic_test(time: 0.01,
               warmup: 0.02,
               formatters: [&Benchee.Formatters.CSV.output/1],
               csv: [file: @file_path])
  end

  defp basic_test(configuration) do
    try do
      capture_io fn ->
        Benchee.run %{
          "Sleep"        => fn -> :timer.sleep(10) end,
          "Sleep longer" => fn -> :timer.sleep(20) end
        }, configuration


        assert File.exists?(@file_path)

        [header, _row_1, _row_2] = @file_path
                                 |> File.stream!
                                 |> CSV.decode
                                 |> Enum.take(3)

        [first_header | _rest] = header
        assert first_header == "Name"
      end
    after
      if File.exists?(@file_path), do: File.rm!(@file_path)
    end
  end

  test "errors when no file was specified" do
    capture_io fn ->
      assert_raise RuntimeError, fn ->
        Benchee.run %{
          time: 0.01,
          warmup: 0,
          formatters: [&Benchee.Formatters.CSV.output/1]
        },
        %{
          "Sleep"        => fn -> :timer.sleep(10) end,
        }
      end
    end
  end
end
