defmodule EvemarketScanner.MixProject do
  use Mix.Project

  def project do
    [
      app: :evemarket_scanner,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {EvemarketScanner.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.5"},
      {:jason, "~> 1.1"},
      {:postgrex, "~> 0.14.1"},
      {:ecto_sql, "~> 3.0"},
      {:joken, "~> 2.0"}
    ]
  end
end
