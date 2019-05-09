defmodule Scrape.IR.FeedItem.ArticleURL do
  @moduledoc false

  alias Scrape.IR.Query
  alias Scrape.IR.URL

  @spec execute(String.t() | [any()], String.t() | nil) :: String.t()

  def execute(dom, url \\ "") do
    link = format_atom(dom) || format_rss(dom)

    case link do
      nil -> ""
      "" -> ""
      _ -> URL.merge(link, url)
    end
  end

  defp format_rss(dom) do
    Query.find(dom, "link", :first)
  end

  defp format_atom(dom) do
    Query.attr(dom, "link", "href", :first)
  end
end
