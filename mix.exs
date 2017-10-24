defmodule BencheeCSV.Mixfile do
  use Mix.Project

  @version "0.7.0"

  def project do
    [app: :benchee_csv,
     version: @version,
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     package: package(),
     test_coverage: [tool: ExCoveralls],
     preferred_cli_env: [
        "coveralls": :test, "coveralls.detail": :test,
        "coveralls.post": :test, "coveralls.html": :test,
        "coveralls.travis": :test],
     name: "BencheeCSV",
     docs: [source_ref: @version],
     source_url: "https://github.com/PragTob/benchee_csv",
     description: """
     Get CSV from your benchee benchmarks to turn them into graphs or whatever!
     """
   ]
  end

  def application do
    [applications: [:logger, :benchee, :csv]]
  end

  defp deps do
    [
      {:benchee,     "~> 0.10"},
      {:csv,         "~> 1.4.0"},
      {:excoveralls, "~> 0.6.1", only: :test},
      {:credo,       "~> 0.5",   only: :dev},
      {:ex_doc,      "~> 0.11",  only: :dev},
      {:earmark,     "~> 1.2",   only: :dev},
      {:dialyxir,    "~> 0.5",   only: :dev, runtime: false}
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
