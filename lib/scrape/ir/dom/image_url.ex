defmodule Scrape.IR.DOM.ImageURL do
  @moduledoc false

  alias Scrape.Tools.DOM

  @spec execute(String.t() | [any()], String.t() | nil) :: nil | String.t()

  def execute(dom, url \\ "") do
    queries = [
      {"meta[property='og:image']", "content"},
      {"meta[name='twitter:image']", "content"}
    ]

    case DOM.first(dom, queries) do
      nil -> nil
      match -> Scrape.IR.URL.merge(match, url)
    end
  end
end
