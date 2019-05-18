defmodule Scrape.IR.DOM.Title do
  @moduledoc false

  alias Scrape.Tools.DOM

  @spec execute(String.t() | [any()], String.t() | nil) :: String.t()

  def execute(dom, _url \\ "") do
    queries = [
      {"meta[property='og:title']", "content"},
      {"meta[property='twitter:title']", "content"},
      {"h1"},
      {"title"}
    ]

    case DOM.first(dom, queries) do
      nil -> ""
      match -> strip_suffix(match)
    end
  end

  defp strip_suffix(value) do
    rx = ~r/\s[|-].{1}.+$/

    case String.match?(value, rx) do
      true -> value |> String.split(rx) |> Scrape.IR.Filter.first()
      false -> value
    end
  end
end
