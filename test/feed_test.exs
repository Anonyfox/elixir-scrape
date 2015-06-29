defmodule FeedTest do
  use ExUnit.Case
  alias Scrape.Feed

  test "parser works" do
    xml = sample_feed "ntv"
    data = Feed.parse xml#, "http://example.com"
  end

  defp sample_feed(name) do
    File.read! "test/sample_data/#{name}-feed.xml"
  end
end
