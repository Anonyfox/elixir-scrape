defmodule Scrape.Flow.Steps.ExtractFeedURLs do
  @moduledoc false

  def execute(state) when not is_map(state) do
    {:error, :no_state_given}
  end

  def execute(%{dom: dom}) when not is_list(dom) and not is_tuple(dom) do
    {:error, :dom_invalid}
  end

  def execute(%{dom: dom, url: url}) do
    {:ok, %{feed_urls: Scrape.IR.DOM.feed_urls(dom, url)}}
  end

  def execute(%{dom: dom}) do
    {:ok, %{feed_urls: Scrape.IR.DOM.feed_urls(dom)}}
  end

  def execute(_map) do
    {:error, :dom_missing}
  end
end
