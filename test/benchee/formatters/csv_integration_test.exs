defmodule Benchee.Formatters.CSVIntegrationTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  @raw_benchmark "raw_benchmark_output.csv"

  test "works just fine" do
    filename = "test.csv"
    basic_test(filename,
               time: 0.01,
               warmup: 0.02,
               formatters: [&Benchee.Formatters.CSV.output/1],
               formatter_options: [csv: [file: filename]])
  end

  test "works just fine when filename is not specified" do
    basic_test("benchmark_output.csv",
               time: 0.01,
               warmup: 0.02,
               formatters: [&Benchee.Formatters.CSV.output/1])
  end

  test "old school configuration still works" do
    filename = "test.csv"
    basic_test(filename,
               time: 0.01,
               warmup: 0.02,
               formatters: [&Benchee.Formatters.CSV.output/1],
               csv: [file: filename])
  end

  defp basic_test(filename, configuration) do
    try do
      capture_io fn ->
        Benchee.run %{
          "Sleep"        => fn -> :timer.sleep(10) end,
          "Sleep longer" => fn -> :timer.sleep(20) end
        }, configuration

        assert File.exists?(filename)
        assert File.exists?(@raw_benchmark)

        assert_header(filename)
        assert_header(@raw_benchmark)
      end
    after
      if File.exists?(filename), do: File.rm!(filename)
      if File.exists?(@raw_benchmark), do: File.rm!(@raw_benchmark)
    end
  end

  defp assert_header(filename) do
    [header, _row_1, _row_2] = filename
                             |> File.stream!
                             |> CSV.decode
                             |> Enum.take(3)

    [first_header | _rest] = header
    assert first_header == "Name"
  end
end
