defmodule Scrape.IR.DOM.Description do
  @moduledoc false

  alias Scrape.IR.DOM.Query

  @spec execute(String.t() | [any()], String.t() | nil) :: String.t()

  def execute(dom, _url \\ "") do
    open_graph(dom) || twitter(dom) || direct(dom) || ""
  end

  defp open_graph(dom) do
    Query.attr(dom, "meta[property='og:description']", "content", :first)
  end

  defp twitter(dom) do
    Query.attr(dom, "meta[name='twitter:description']", "content", :first)
  end

  defp direct(dom) do
    Query.attr(dom, "meta[name='description']", "content", :first)
  end
end
