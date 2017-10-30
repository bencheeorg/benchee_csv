defmodule Benchee.Formatters.CSV.General do
  alias Benchee.{Statistics, Benchmark.Scenario}

  @column_descriptors ["Name", "Input", "Iterations per Second", "Average",
                       "Standard Deviation",
                       "Standard Deviation Iterations Per Second",
                       "Standard Deviation Ratio", "Median", "Minimum",
                       "Maximum", "Sample Size"]
  def add_headers(scenarios) do
    [@column_descriptors | scenarios]
  end

  def to_csv(%Scenario{
                job_name: name,
                input_name: input_name,
                run_time_statistics: %Statistics{
                                       ips:           ips,
                                       average:       average,
                                       std_dev:       std_dev,
                                       std_dev_ips:   std_dev_ips,
                                       std_dev_ratio: std_dev_ratio,
                                       median:        median,
                                       minimum:       minimum,
                                       maximum:       maximum,
                                       sample_size:   sample_size}}) do
    [name, input_name, ips, average, std_dev, std_dev_ips, std_dev_ratio,
     median, minimum, maximum, sample_size]
  end
end
