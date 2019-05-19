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
      # enable development with `mix test.watch --stale`
      {:mix_test_watch, "~> 0.8", only: :dev, runtime: false},
      # documentation generation
      {:ex_doc, "~> 0.20.2", only: :dev, runtime: false},
      # language detection
      {:paasaa, "~> 0.3.1"},
      # snowball stemmer for multiple languages with a NIF
      {:stemex, "~> 0.1.1"},
      # HTML/XML parser with CSS3 selectors
      {:floki, "~> 0.21.0"},
      # clone of arc90's readability algorithm
      {:readability, "~> 0.10.0"},
      # iconv written in pure elixir
      {:codepagex, "~> 0.1.4"},
      # http client
      {:httpoison, "~> 1.5", override: true},
      # xml to map
      {:xmap, "~> 0.2.4"},
      # map transformation functions
      {:morphix, "~> 0.7.0"}
    ]
  end
end
