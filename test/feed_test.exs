defmodule FeedTest do
  use ExUnit.Case, async: true
  alias Scrape.Feed

  test "parser works" do
    xml = sample_feed "elixirlang"
    data = Feed.parse xml, "http://example.com"
    # require Logger
    # Logger.debug(inspect data, pretty: true)
  end

  test "parser works for german" do
    xml = sample_feed "ntv"
    data = Feed.parse xml, "http://example.com"
    # require Logger
    # Logger.debug(inspect data, pretty: true)
  end

  test "parser works for german with ISO" do
    xml = sample_feed "spiegel"
    data = Feed.parse xml, "http://example.com"
    # require Logger
    # Logger.debug(inspect data, pretty: true)
  end

  defp sample_feed(name) do
    File.read! "test/sample_data/#{name}-feed.xml"
  end
end
