defmodule Scrape.IR.DOM.Title do
  @moduledoc false

  alias Scrape.IR.Query

  @spec execute(String.t() | [any()], String.t() | nil) :: String.t()

  def execute(dom, _url \\ "") do
    match = open_graph(dom) || twitter(dom) || headline(dom) || direct(dom) || ""
    strip_suffix(match)
  end

  defp open_graph(dom) do
    Query.attr(dom, "meta[property='og:title']", "content", :first)
  end

  defp twitter(dom) do
    Query.attr(dom, "meta[property='twitter:title']", "content", :first)
  end

  defp headline(dom) do
    Query.find(dom, "h1", :first)
  end

  defp direct(dom) do
    Query.find(dom, "title", :first)
  end

  defp strip_suffix(value) do
    rx = ~r/\s[|-].{1}.+$/

    case String.match?(value, rx) do
      true -> value |> String.split(rx) |> Scrape.IR.Filter.first()
      false -> value
    end
  end
end
