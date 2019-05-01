defmodule Scrape.MixProject do
  use Mix.Project

  def project do
    [
      app: :scrape,
      version: "3.0.0",
      elixir: "~> 1.8",
      description: description(),
      package: package(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Scrape.Application, []}
    ]
  end

  defp description do
    """
    Scrape any website, article or RSS/Atom feed with ease!
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md", "LICENSE.txt"],
      maintainers: ["Maximilian Stroh"],
      licenses: ["LGPLv3"],
      links: %{"GitHub" => "https://github.com/Anonyfox/elixir-scrape"}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:mix_test_watch, "~> 0.8", only: :dev, runtime: false},
      {:paasaa, "~> 0.3.1"},
      {:stemex, "~> 0.1.1"}
    ]
  end
end
