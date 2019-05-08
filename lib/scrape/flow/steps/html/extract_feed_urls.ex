defmodule Scrape.Flow.Steps.HTML.ExtractFeedURLs do
  @moduledoc false

  use Scrape.Flow.Step

  def execute(%{dom: dom}, _) when not is_list(dom) and not is_tuple(dom) do
    fail(:dom_invalid)
  end

  def execute(%{dom: dom, url: url}, _) do
    assign(feed_urls: Scrape.IR.DOM.feed_urls(dom, url))
  end

  def execute(%{dom: dom}, _) do
    assign(feed_urls: Scrape.IR.DOM.feed_urls(dom))
  end

  def execute(_, _) do
    fail(:dom_missing)
  end
end
