defmodule Scrape.IR.FeedTest do
  use ExUnit.Case

  alias Scrape.IR.Feed

  doctest Feed

  describe "Feed#title/1" do
    test "can extract from xml string of type atom" do
      assert Feed.title("<feed><title>abc</title></feed>") == "abc"
    end

    test "can extract from xml string of type rss" do
      assert Feed.title("<rss><channel><title>abc</title></channel></rss>") == "abc"
    end

    test "can extract from german atom feed" do
      html = File.read!("cache/feed/heise.xml")
      assert Feed.title(html) == "heise online News"
    end

    test "can extract from german rss feed" do
      html = File.read!("cache/feed/spiegel.xml")
      assert Feed.title(html) == "SPIEGEL ONLINE - Schlagzeilen"
    end

    test "can extract from english atom feed" do
      html = File.read!("cache/feed/elixir-lang.xml")
      assert Feed.title(html) == "Elixir Lang"
    end

    test "can extract from english rss feed" do
      html = File.read!("cache/feed/latimes.xml")
      assert Feed.title(html) == "latimes.com - Los Angeles Times"
    end
  end

  describe "Feed#description/1" do
    test "can extract from xml string of type atom" do
      xml = "<feed><description>abc</description></feed>"
      assert Feed.description(xml) == "abc"
    end

    test "can extract from xml string of type rss" do
      xml = "<rss><channel><description>abc</description></channel></rss>"
      assert Feed.description(xml) == "abc"
    end

    test "can extract from german atom feed" do
      xml = File.read!("cache/feed/heise.xml")
      assert Feed.description(xml) == "Nachrichten nicht nur aus der Welt der Computer"
    end

    test "can extract from german rss feed" do
      xml = File.read!("cache/feed/spiegel.xml")
      assert Feed.description(xml) =~ "Alles Wichtige aus"
    end

    test "can extract from english atom feed" do
      xml = File.read!("cache/feed/elixir-lang.xml")
      assert Feed.description(xml) == nil
    end

    test "can extract from english rss feed" do
      xml = File.read!("cache/feed/latimes.xml")
      assert Feed.description(xml) =~ "source of breaking news"
    end
  end

  describe "Feed#website_url/1" do
    test "can extract from xml string of type atom" do
      xml = "<feed><link href='http://example.com' /></feed>"
      assert Feed.website_url(xml) == "http://example.com"
    end

    test "can extract from xml string of type rss" do
      xml = "<rss><channel><link>http://example.com</link></channel></rss>"
      assert Feed.website_url(xml) == "http://example.com"
    end

    test "can extract from german atom feed" do
      xml = File.read!("cache/feed/heise.xml")
      assert Feed.website_url(xml) == "https://www.heise.de"
    end

    test "can extract from german rss feed" do
      xml = File.read!("cache/feed/spiegel.xml")
      assert Feed.website_url(xml) == "http://www.spiegel.de"
    end

    test "can extract from english atom feed" do
      xml = File.read!("cache/feed/elixir-lang.xml")
      assert Feed.website_url(xml) == "http://elixir-lang.org"
    end

    test "can extract from english rss feed" do
      xml = File.read!("cache/feed/latimes.xml")
      assert Feed.website_url(xml) == "http://www.latimes.com"
    end
  end
end
