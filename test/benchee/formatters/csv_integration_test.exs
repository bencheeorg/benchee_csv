defmodule Benchee.Formatters.CSVIntegrationTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  @filename "benchmark_output.csv"
  @raw_filename "benchmark_output_raw.csv"

  test "works just fine" do
    basic_test(time: 0.01,
               warmup: 0.02,
               formatters: [&Benchee.Formatters.CSV.output/1],
               formatter_options: [csv: [file: @filename]])
  end

  test "works just fine when filename is not specified" do
    basic_test(time: 0.01,
               warmup: 0.02,
               formatters: [&Benchee.Formatters.CSV.output/1])
  end

  test "old school configuration still works" do
    basic_test(time: 0.01,
               warmup: 0.02,
               formatters: [&Benchee.Formatters.CSV.output/1],
               csv: [file: @filename])
  end

  defp basic_test(configuration) do
    try do
      capture_io fn ->
        Benchee.run %{
          "Sleep"        => fn -> :timer.sleep(10) end,
          "Sleep longer" => fn -> :timer.sleep(20) end
        }, configuration

        assert File.exists?(@filename)
        assert File.exists?(@raw_filename)

        assert_header(@filename)
        assert_value(@filename)

        assert_header(@raw_filename)
        assert_value(@raw_filename)
      end
    after
      if File.exists?(@filename), do: File.rm!(@filename)
      if File.exists?(@raw_filename), do: File.rm!(@raw_filename)
    end
  end

  defp assert_header(filename) do
    header = filename
             |> File.stream!
             |> CSV.decode!
             |> Enum.take(1)
             |> Enum.at(0)

    [first_header | _rest] = header
    assert first_header == "Name"
  end

  defp assert_value(filename) do
    values = filename
             |> File.stream!
             |> CSV.decode!
             |> Enum.take(2)
             |> Enum.at(1)

    assert String.to_float(Enum.at(values, 2)) > 0
  end
end
