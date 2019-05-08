defmodule Scrape.IR.DOM.ImageURL do
  @moduledoc false

  alias Scrape.IR.Query

  @spec execute(String.t() | [any()], String.t() | nil) :: String.t()

  def execute(dom, url \\ "") do
    link = open_graph(dom) || twitter(dom) || ""
    Scrape.IR.URL.merge(link, url)
  end

  defp open_graph(dom) do
    Query.attr(dom, "meta[property='og:image']", "content", :first)
  end

  defp twitter(dom) do
    Query.attr(dom, "meta[name='twitter:image']", "content", :first)
  end
end
