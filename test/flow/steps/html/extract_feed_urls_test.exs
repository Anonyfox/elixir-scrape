defmodule Scrape.Flow.Steps.HTML.ExtractFeedURLsTest do
  use ExUnit.Case

  alias Scrape.Flow.Steps.HTML.ExtractFeedURLs

  test "refuses if no assigns are given" do
    assert ExtractFeedURLs.execute(nil) == {:error, :no_assigns_given}
  end

  test "refuses if dom not existing in assigns" do
    assert ExtractFeedURLs.execute(%{}) == {:error, :dom_missing}
  end

  test "refuses if dom is nil" do
    assert ExtractFeedURLs.execute(%{dom: nil}) == {:error, :dom_invalid}
  end

  test "refuses if dom is not parsed" do
    assert ExtractFeedURLs.execute(%{dom: ""}) == {:error, :dom_invalid}
  end

  test "works if non-empty html string is given" do
    dom = Floki.parse("<html><link rel='alternate' href='/feed.rss'></html>")
    assert ExtractFeedURLs.execute(%{dom: dom}) == {:ok, %{feed_urls: ["/feed.rss"]}}
  end

  test "does not normalize url if root_url is nil" do
    dom = Floki.parse("<html><link rel='alternate' href='/feed.rss'></html>")
    url = nil
    {:ok, data} = ExtractFeedURLs.execute(%{dom: dom, url: url})
    assert data.feed_urls == ["/feed.rss"]
  end

  test "normalizes url if root_url is given" do
    dom = Floki.parse("<html><link rel='alternate' href='/feed.rss'></html>")
    url = "http://example.com"
    {:ok, data} = ExtractFeedURLs.execute(%{dom: dom, url: url})
    assert data.feed_urls == ["http://example.com/feed.rss"]
  end
end
