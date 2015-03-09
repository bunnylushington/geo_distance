defmodule GeoDistance.Mixfile do
  use Mix.Project

  def project do
    [app: :geo_distance,
     version: "1.0.0",
     elixir: "~> 1.0",
     package: package,
     deps: deps]
  end

  def application do
    [applications: [:logger]]
  end

  defp package do
    [
        files: ["lib", "mix.exs", "README*", "LICENSE*", "test"],
        contributors: ["Kevin Montuori", "Kocomojo, LLC"],
        licenses: ["MIT"],
    ]
  end
  defp deps do
    [
        {:earmark, "~> 0.1", only: :dev},
        {:ex_doc,  "~> 0.6", only: :dev}
    ]
  end
end
