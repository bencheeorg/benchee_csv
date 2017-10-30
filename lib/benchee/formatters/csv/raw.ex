defmodule Benchee.Formatters.CSV.Raw do
  alias Benchee.Benchmark.Scenario

  def add_headers(scenarios) do
    [generate_heders_for_run_times(Enum.fetch!(scenarios, 0)) | scenarios]
  end

  def generate_heders_for_run_times(scenario) do
    headers_for_measurements = scenario
      |> Enum.drop(2)
      |> Enum.with_index()
      |> Enum.map(fn({_measurement, index}) -> "Measurement#{index+1}" end)

    Enum.concat(["Name", "Input"], headers_for_measurements)
  end

  def to_csv(%Scenario{
                job_name: name,
                input_name: input_name,
                run_times: run_times}) do
    Enum.concat([name, input_name], run_times)
  end
end
