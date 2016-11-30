defmodule BencheeCSV.Mixfile do
  use Mix.Project

  @version "0.4.0"

  def project do
    [app: :benchee_csv,
     version: @version,
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     package: package,
     name: "BencheeCSV",
     docs: [source_ref: @version],
     source_url: "https://github.com/PragTob/benchee_csv",
     description: """
     Get CSV from your benchee benchmarks to them into graphs or whatever!
     """
   ]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [
      {:benchee, "~> 0.6", git: "git@github.com:PragTob/benchee.git"},
      {:csv,     "~> 1.4.0"},
      {:credo,   "~> 0.5",  only: :dev},
      {:ex_doc,  "~> 0.11", only: :dev},
      {:earmark, "~> 1.0.1",  only: :dev}
    ]
  end

  defp package do
    [
      maintainers: ["Tobias Pfeiffer"],
      licenses: ["MIT"],
      links: %{github: "https://github.com/PragTob/benchee_csv"}
    ]
  end
end
