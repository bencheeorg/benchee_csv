defmodule Benchee.Utility.File do
  @moduledoc """
  Methods to create files used in plugins.
  """

  def each_input(inputs_to_content, filename, function) do
    Enum.each inputs_to_content, fn({input_name, content}) ->
      input_filename = interleave(filename, input_name)
      File.open input_filename, [:write], fn(file) ->
        function.(file, content)
      end
    end
  end

  @doc """
  Gets file name/path and the input name together.

  ## Examples

      iex> Benchee.Utility.File.interleave("abc.csv", "hello")
      "abc_hello.csv"

      iex> Benchee.Utility.File.interleave("abc.csv", "Big Input")
      "abc_big_input.csv"

      iex> Benchee.Utility.File.interleave("bench/abc.csv", "Big Input")
      "bench/abc_big_input.csv"

      iex> marker = Benchee.Benchmark.no_input
      iex> Benchee.Utility.File.interleave("abc.csv", marker)
      "abc.csv"
  """
  def interleave(filename, input) do
    Path.rootname(filename) <> to_filename(input) <> Path.extname(filename)
  end

  defp to_filename(input_string) do
    no_input = Benchee.Benchmark.no_input
    case input_string do
      ^no_input -> ""
      _         ->
        String.downcase("_" <> String.replace(input_string, " ", "_"))
    end
  end
end

defmodule Benchee.Formatters.CSV do

  @moduledoc """
  Functionality for converting Benchee benchmarking results to CSV so that
  they can be written to file and opened in a spreadsheet tool for graph
  generation for instance.

  The most basic use case is to configure it as one of the formatters to be
  used by `Benchee.run/2`.

      Benchee.run(
      %{
        "flat_map"    => fn -> Enum.flat_map(list, map_fun) end,
        "map.flatten" => fn -> list |> Enum.map(map_fun) |> List.flatten end
      },
        formatters: [
          &Benchee.Formatters.CSV.output/1,
          &Benchee.Formatters.Console.output/1
        ],
        csv: %{file: "my.csv"}
      )

  """

  @doc """
  Uses `Benchee.Formatters.CSV.format/1` to transform the statistics output to
  a CSV, but also already writes it to a file defined in the initial
  configuration under `%{csv: %{file: "my.csv"}}`
  """
  def output(map)
  def output(suite = %{config: %{csv: %{file: filename}} }) do
    suite
    |> format
    |> write_csv_to_file(filename)

    suite
  end
  def output(_suite) do
    raise "You need to specify a file to write the csv to in the configuration as %{csv: %{file: \"my.csv\"}}"
  end

  defp write_csv_to_file(input_to_content, filename) do
    Benchee.Utility.File.each_input input_to_content,
                                    filename,
                                    fn(file, csv_list) ->
      Enum.each(csv_list, fn(row) -> IO.write(file, row) end)
    end
  end

  @column_descriptors ["Name", "Iterations per Second", "Average",
                       "Standard Deviation",
                       "Standard Deviation Iterations Per Second",
                       "Standard Deviation Ratio", "Median", "Minimum",
                       "Maximum", "Sample Size"]

  @doc """
  Transforms the statistical results `Benche.statistics` to be written
  somewhere, such as a file through `IO.write/2`.

  ## Examples

      iex> suite = %{
      ...>   statistics: %{
      ...>     "Some Input" => %{
      ...>       "My Job" => %{
      ...>         average: 200.0,
      ...>         ips: 5000.0,
      ...>         std_dev: 20,
      ...>         std_dev_ratio: 0.1,
      ...>         std_dev_ips: 500,
      ...>         median: 190.0,
      ...>         minimum: 180,
      ...>         maximum: 250,
      ...>         sample_size: 243
      ...>       }
      ...>     }
      ...>   }
      ...> }
      iex> suite
      iex> |> Benchee.Formatters.CSV.format
      iex> |> Map.get("Some Input")
      iex> |> Enum.take(2)
      ["Name,Iterations per Second,Average,Standard Deviation,Standard Deviation Iterations Per Second,Standard Deviation Ratio,Median,Minimum,Maximum,Sample Size\\r\\n",
       "My Job,5.0e3,200.0,20,500,0.1,190.0,180,250,243\\r\\n"]

  """
  def format(%{statistics: jobs_per_input}) do
    input_to_content = Enum.map(jobs_per_input, fn({input_key, statistics}) ->

      sorted = Benchee.Statistics.sort(statistics)
      content = [@column_descriptors | job_csvs(sorted)]
                |> CSV.encode

      {input_key, content}
    end)

    Map.new input_to_content
  end

  defp job_csvs(jobs) do
    Enum.map(jobs, &to_csv/1)
  end

  defp to_csv({name, %{ips:           ips,
                       average:       average,
                       std_dev:       std_dev,
                       std_dev_ips:   std_dev_ips,
                       std_dev_ratio: std_dev_ratio,
                       median:        median,
                       minimum:       minimum,
                       maximum:       maximum,
                       sample_size:   sample_size}}) do
    [name, ips, average, std_dev, std_dev_ips, std_dev_ratio, median, minimum,
    maximum, sample_size]
  end
end
