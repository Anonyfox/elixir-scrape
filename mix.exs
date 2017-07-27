defmodule Scrape.Mixfile do
  use Mix.Project

  def project do
    [app: :scrape,
     version: "2.0.0",
     elixir: "~> 1.4",
     description: description(),
     package: package(),
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     dialyzer: [plt_add_deps: true],
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger, :httpoison, :tzdata,
                    :floki, :parallel, :timex, :codepagex]]
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
      {:floki,      "~> 0.14"}, # html/xml parser
      {:html5ever, "~> 0.5.0"}, # browser grade html parser (Rust NIF)
      {:httpoison,  "~> 0.11"}, # http client
      {:codepagex,  "~> 0.1.4"}, # iconv written in pure elixir
      {:timex,      "~> 2.2.1"}, # date/time processing
      {:parallel,   "~> 0.0.3"}, # easy parallel processing
      {:codepagex, "~> 0.1.4"}, # convert between encodings
      {:dogma,      "~> 0.1.6", only: :dev}, # static code linter
      {:ex_doc, ">= 0.0.0", only: :dev} # required now
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
