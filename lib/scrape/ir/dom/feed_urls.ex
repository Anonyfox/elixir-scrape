defmodule Scrape.IR.DOM.FeedURLs do
  @moduledoc false

  alias Scrape.Tools.DOM

  @spec execute(String.t() | [any()], String.t() | nil) :: [String.t()]

  def execute(dom, url \\ "") do
    list = meta_tag(dom) ++ inline(dom)

    list
    |> Enum.filter(&Scrape.IR.URL.is_http?(&1))
    |> Enum.map(&Scrape.IR.URL.merge(&1, url))
    |> Enum.uniq()
  end

  defp meta_tag(dom) do
    selector = """
      link[type='application/rss+xml'],
      link[type='application/atom+xml'],
      link[rel='alternate']
    """

    DOM.attrs(dom, selector, "href")
  end

  defp inline(dom) do
    rx = ~r{href=['"]([^'"]*(rss|atom|feed|xml)[^'"]*)['"]}
    str = Floki.raw_html(dom)
    matches = Regex.scan(rx, str, capture: :all_but_first)
    Enum.map(matches, &List.first/1)
  end
end
