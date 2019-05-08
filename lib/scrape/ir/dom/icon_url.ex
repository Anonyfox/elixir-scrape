defmodule Scrape.IR.DOM.IconURL do
  @moduledoc false

  alias Scrape.IR.Query

  @spec execute(String.t() | [any()], String.t() | nil) :: String.t()

  def execute(dom, url \\ "") do
    selector = """
      link[rel='apple-touch-icon'],
      link[rel='apple-touch-icon-precomposed'],
      link[rel='shortcut icon'],
      link[rel='icon']
    """

    link = Query.attr(dom, selector, "href", :first)
    Scrape.IR.URL.merge(link, url)
  end
end
