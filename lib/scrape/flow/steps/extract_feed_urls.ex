defmodule Scrape.Flow.Steps.ExtractFeedURLs do
  @moduledoc false

  def execute(%{dom: dom, url: url}) do
    {:ok, %{feed_urls: Scrape.IR.DOM.feed_urls(dom, url)}}
  end
end
