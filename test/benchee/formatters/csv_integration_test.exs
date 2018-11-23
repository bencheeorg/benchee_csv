defmodule Benchee.Formatters.CSVIntegrationTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  @filename "benchmark_output.csv"
  @raw_filename "benchmark_output_raw.csv"

  test "works just fine" do
    basic_test(
      time: 0.01,
      warmup: 0.02,
      formatters: [{Benchee.Formatters.CSV, file: @filename}]
    )
  end

  test "works just fine when filename is not specified" do
    basic_test(
      time: 0.01,
      warmup: 0.02,
      formatters: [Benchee.Formatters.CSV]
    )
  end

  defp basic_test(configuration) do
    capture_io(fn ->
      Benchee.run(
        %{
          "Sleep" => fn -> :timer.sleep(10) end,
          "Sleep longer" => fn -> :timer.sleep(20) end
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
    header = csv_row_at(filename, 0)

    [first_header | _rest] = header
    assert first_header == "Name"
  end

  defp assert_value(filename) do
    values = csv_row_at(filename, 1)

    assert String.to_float(Enum.at(values, 2)) > 0
  end

  defp csv_row_at(filename, index) do
    filename
    |> File.stream!()
    |> CSV.decode!()
    |> Enum.take(index + 1)
    |> Enum.at(index)
  end

  defp assert_raw_header(filename) do
    assert ["Sleep", "Sleep longer"] = csv_row_at(filename, 0)
  end

  defp assert_raw_value(filename) do
    raw_values = csv_row_at(filename, 1)

    assert length(raw_values) == 2

    Enum.each(raw_values, fn value ->
      assert String.to_float(value) > 0
    end)
  end
end
