defmodule BencheeCSV.Mixfile do
  use Mix.Project

  def project do
    [app: :benchee_csv,
     version: "0.2.0",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     package: package,
     name: "BencheeCSV",
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
      {:benchee, git: "git://github.com/PragTob/benchee.git"},
      {:csv,     "~> 1.4.0"},
      {:ex_doc,  "~> 0.11", only: :dev},
      {:earmark, "~> 0.2",  only: :dev}
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
