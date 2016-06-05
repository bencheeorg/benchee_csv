defmodule BencheeCSV.Mixfile do
  use Mix.Project

  def project do
    [app: :benchee_csv,
     version: "0.1.0",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     package: package,
     name: "BencheeCSV"]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [
      {:benchee, "~> 0.1"},
      {:csv,     "~> 1.4.0"}
    ]
  end

  defp package do
    [
      maintainers: ["Tobias Pfeiffer"],
      licenses: ["MIT"]
    ]
  end
end
