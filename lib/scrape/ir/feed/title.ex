defmodule Scrape.IR.Feed.Title do
  @moduledoc false

  alias Scrape.IR.Query

  @spec execute(String.t() | [any()]) :: String.t()

  def execute(dom) do
    format_atom(dom) || format_rss(dom)
  end

  defp format_rss(dom) do
    Query.find(dom, "channel > title", :first)
  end

  defp format_atom(dom) do
    Query.find(dom, "feed > title", :first)
  end
end
