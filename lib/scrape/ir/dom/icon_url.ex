defmodule Scrape.IR.DOM.IconURL do
  @moduledoc false

  alias Scrape.Tools.DOM

  @spec execute(String.t() | [any()], String.t() | nil) :: nil | String.t()

  def execute(dom, url \\ "") do
    queries = [
      {"link[rel='apple-touch-icon']", "href"},
      {"link[rel='apple-touch-icon-precomposed']", "href"},
      {"link[rel='shortcut icon']", "href"},
      {"link[rel='icon']", "href"}
    ]

    case DOM.first(dom, queries) do
      nil -> nil
      match -> Scrape.IR.URL.merge(match, url)
    end
  end
end
