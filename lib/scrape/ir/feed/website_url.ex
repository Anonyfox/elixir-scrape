defmodule Scrape.IR.Feed.WebsiteURL do
  @moduledoc false

  alias Scrape.IR.Query
  alias Scrape.IR.URL

  @spec execute(String.t() | [any()]) :: String.t()

  def execute(dom) do
    url = format_atom(dom) || format_rss(dom)
    normalize(url)
  end

  defp format_rss(dom) do
    Query.find(dom, "channel > link", :first)
  end

  defp format_atom(dom) do
    Query.attr(dom, "feed > link", "href", :shortest)
  end

  defp normalize(nil), do: ""
  defp normalize(""), do: ""
  defp normalize(url), do: url |> URL.base()
end
