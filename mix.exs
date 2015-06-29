defmodule Scrape.Mixfile do
  use Mix.Project

  def project do
    [app: :scrape,
     version: "0.0.1",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     dialyzer: [plt_add_deps: true],
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger, :httpoison]]
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
      {:floki, "~> 0.3"}, # html parser
      {:httpoison, "~> 0.7"}, # http client
      {:feeder_ex, "~> 0.0.2"}, # RSS/Atom parser
      {:mix_test_watch, "~> 0.1.1", only: :dev}, # run tests on file changes
      {:dogma, "~> 0.0.1", only: :dev} # static code linter
    ]
  end
end
