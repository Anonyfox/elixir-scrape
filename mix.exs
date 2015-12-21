defmodule Scrape.Mixfile do
  use Mix.Project

  def project do
    [app: :scrape,
     version: "1.0.4",
     elixir: "~> 1.0",
     description: description,
     package: package,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     dialyzer: [plt_add_deps: true],
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger, :httpoison, :tzdata]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      {:floki,      "~> 0.6"}, # html/xml parser
      {:httpoison,  "~> 0.8"}, # http client
      {:codepagex,  "~> 0.1.2"}, # iconv written in pure elixir
      {:timex,      "~> 0.19"}, # date/time processing
      {:parallel,   "~> 0.0.3"}, # easy parallel processing
      {:dogma,      "~> 0.0.1", only: :dev} # static code linter
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
end
