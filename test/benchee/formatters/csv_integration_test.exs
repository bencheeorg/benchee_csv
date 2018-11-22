defmodule Benchee.Formatters.CSVIntegrationTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  @filename "benchmark_output.csv"
  @raw_filename "benchmark_output_raw.csv"

  test "works just fine" do
    basic_test(
      time: 0.01,
      memory_time: 0.01,
      warmup: 0.02,
      formatters: [{Benchee.Formatters.CSV, file: @filename}]
    )
  end

  test "works just fine when filename is not specified" do
    basic_test(
      time: 0.01,
      memory_time: 0.01,
      warmup: 0.02,
      formatters: [Benchee.Formatters.CSV]
    )
  end

  defp basic_test(configuration) do
    capture_io(fn ->
      Benchee.run(
        %{
          "Sleep" => fn -> :timer.sleep(10) end,
          "List" => fn -> [:rand.uniform()] end
        },
        configuration
      )

      assert File.exists?(@filename)
      assert File.exists?(@raw_filename)

      assert_header(@filename)
      assert_value(@filename)

      assert_raw_header(@raw_filename)
      assert_raw_value(@raw_filename)
    end)
  after
    if File.exists?(@filename), do: File.rm!(@filename)
    if File.exists?(@raw_filename), do: File.rm!(@raw_filename)
  end

  defp assert_header(filename) do
    assert [
             "Name",
             "Input",
             "Iterations per Second",
             "Standard Deviation Iterations Per Second",
             "Run Time Average",
             "Run Time Median",
             "Run Time Minimum",
             "Run Time Maximum",
             "Run Time Standard Deviation",
             "Run Time Standard Deviation Ratio",
             "Run Time Sample Size",
             "Memory Usage Average",
             "Memory Usage Median",
             "Memory Usage Minimum",
             "Memory Usage Maximum",
             "Memory Usage Standard Deviation",
             "Memory Usage Standard Deviation Ratio",
             "Memory Usage Sample Size"
           ] = csv_row_at(filename, 0)
  end

  defp assert_value(filename) do
    values = csv_row_at(filename, 1)
    assert length(values) == 18

    assert String.to_float(Enum.at(values, 2)) >= 0
  end

  defp assert_raw_header(filename) do
    assert [
             "List (Run Time Measurements)",
             "List (Memory Usage Measurements)",
             "Sleep (Run Time Measurements)",
             "Sleep (Memory Usage Measurements)"
           ] = csv_row_at(filename, 0)
  end

  defp assert_raw_value(filename) do
    raw_values = csv_row_at(filename, 1)

    assert length(raw_values) == 4

    Enum.each(raw_values, fn value ->
      {float, _} = Float.parse(value)
      assert float >= 0
    end)
  end

  defp csv_row_at(filename, index) do
    filename
    |> File.stream!()
    |> CSV.decode!()
    |> Enum.take(index + 1)
    |> Enum.at(index)
  end
end
