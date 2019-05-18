defmodule Scrape.IR.DOM.Description do
  @moduledoc false

  alias Scrape.Tools.DOM

  @spec execute(String.t() | [any()], String.t() | nil) :: String.t()

  def execute(dom, _url \\ "") do
    queries = [
      {"meta[property='og:description']", "content"},
      {"meta[name='twitter:description']", "content"},
      {"meta[name='description']", "content"}
    ]

    case DOM.first(dom, queries) do
      nil -> ""
      match -> match
    end
  end
end
