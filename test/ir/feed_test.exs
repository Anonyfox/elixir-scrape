defmodule Scrape.IR.FeedTest do
  use ExUnit.Case

  alias Scrape.IR.Feed

  doctest Feed

  describe "Feed#title/1" do
    test "can extract title from xml string of type atom" do
      assert Feed.title("<feed><title>abc</title></feed>") == "abc"
    end

    test "can extract title from xml string of type rss" do
      assert Feed.title("<rss><channel><title>abc</title></channel></rss>") == "abc"
    end

    test "can extract title from german atom feed" do
      html = File.read!("cache/feed/heise.xml")
      assert Feed.title(html) == "heise online News"
    end

    test "can extract title from german rss feed" do
      html = File.read!("cache/feed/spiegel.xml")
      assert Feed.title(html) == "SPIEGEL ONLINE - Schlagzeilen"
    end

    test "can extract title from english atom feed" do
      html = File.read!("cache/feed/elixir-lang.xml")
      assert Feed.title(html) == "Elixir Lang"
    end

    test "can extract title from english rss feed" do
      html = File.read!("cache/feed/latimes.xml")
      assert Feed.title(html) == "latimes.com - Los Angeles Times"
    end
  end
end
