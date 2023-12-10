# benchee_csv [![Hex Version](https://img.shields.io/hexpm/v/benchee_csv.svg)](https://hex.pm/packages/benchee_csv) [![docs](https://img.shields.io/badge/docs-hexpm-blue.svg)](https://hexdocs.pm/benchee_csv/) [![CI](https://github.com/bencheeorg/benchee_csv/actions/workflows/main.yml/badge.svg)](https://github.com/bencheeorg/benchee_csv/actions/workflows/main.yml) [![Coverage Status](https://coveralls.io/repos/github/bencheeorg/benchee_csv/badge.svg?branch=main)](https://coveralls.io/github/bencheeorg/benchee_csv?branch=main)

Formatter for [benchee](https://github.com/PragTob/benchee) to turn the statistics output into a CSV file. This can then be used in the Spreadsheet tool of your choice to generate graphs to your liking.

These might then look like this one (quickly generated with LibreOffice from the output of the sample):

![sample graphs](http://www.pragtob.info/images/benchee_csv.png)

## Installation

Add benchee_csv to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:benchee_csv, "~> 1.0", only: :dev}]
end
```

Afterwards, run `mix deps.get` to install it.

## Usage

Simply configure `Benchee.Formatters.CSV` as one of the formatters for `Benchee.run/2` along with the file path you want the output to go (otherwise defaults to "benchmark_output.csv"):

```elixir
list = Enum.to_list(1..10_000)
map_fun = fn i -> [i, i * i] end

Benchee.run(
  %{
    "flat_map" => fn -> Enum.flat_map(list, map_fun) end,
    "map.flatten" => fn -> list |> Enum.map(map_fun) |> List.flatten() end
  },
  formatters: [
    {Benchee.Formatters.CSV, file: "my.csv"},
    Benchee.Formatters.Console
  ]
```

The sample defines both the standard console formatter and the CSV formatter, if you don't care about the console output you can just delet that line.

You can also use the more verbose and versatile API of Benchee. When it comes to formatting just use `Benchee.Formatters.CSV.format/2` and then write it to a file (taking into account the new input structure). Check out the [samples directory](https://github.com/PragTob/benchee_csv/tree/master/samples) for the verbose samples to see how it's done.

## Contributing

Contributions to benchee_csv are very welcome! Bug reports, documentation, spelling corrections, whole features, feature ideas, bugfixes, new plugins, fancy graphics... all of those (and probably more) are much appreciated contributions!

Please respect the [Code of Conduct](//github.com/PragTob/benchee_csv/blob/master/CODE_OF_CONDUCT.md).

You can get started with a look at the [open issues](https://github.com/PragTob/benchee_csv/issues).

A couple of (hopefully) helpful points:

* Feel free to ask for help and guidance on an issue/PR ("How can I implement this?", "How could I test this?", ...)
* Feel free to open early/not yet complete pull requests to get some early feedback
* When in doubt if something is a good idea open an issue first to discuss it
* In case I don't respond feel free to bump the issue/PR or ping me on other places

## Development

* `mix deps.get` to install dependencies
* `mix test` to run tests
* `mix credo` or `mix credo --strict` to find code style problems (not too strict with the 80 width limit for sample output in the docs)
