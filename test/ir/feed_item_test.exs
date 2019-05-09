defmodule Scrape.IR.FeedItemTest do
  use ExUnit.Case

  alias Scrape.IR.FeedItem

  doctest FeedItem

  describe "FeedItem#title/1" do
    test "can extract from xml string of type atom" do
      xml = "<feed><entry><title>abc</title></entry></feed>"
      assert FeedItem.title(xml) == "abc"
    end

    test "can extract from xml string of type rss" do
      xml = "<feed><item><title>abc</title></item></feed>"
      assert FeedItem.title(xml) == "abc"
    end

    test "can extract from german atom feed" do
      xml = File.read!("cache/feed/heise.xml")
      item = xml |> Floki.find("entry") |> List.first()
      assert FeedItem.title(item) =~ "Fachkräftemangel"
    end

    test "can extract from german rss feed" do
      xml = File.read!("cache/feed/spiegel.xml")
      item = xml |> Floki.find("item") |> List.first()
      assert FeedItem.title(item) =~ "Schwertransporter"
    end

    test "can extract from english atom feed" do
      xml = File.read!("cache/feed/elixir-lang.xml")
      item = xml |> Floki.find("entry") |> List.first()
      assert FeedItem.title(item) == "Elixir v1.0 released"
    end

    test "can extract from english rss feed" do
      xml = File.read!("cache/feed/latimes.xml")
      item = xml |> Floki.find("item") |> List.first()
      assert FeedItem.title(item) =~ "Essential tracks"
    end
  end

  describe "FeedItem#description/1" do
    test "can extract from xml string of type atom" do
      xml = "<feed><entry><summary>abc</summary></entry></feed>"
      assert FeedItem.description(xml) == "abc"
    end

    test "can extract from xml string of type rss" do
      xml = "<rss><item><description>abc</description></item></rss>"
      assert FeedItem.description(xml) == "abc"
    end

    test "can extract from german atom feed" do
      xml = File.read!("cache/feed/heise.xml")
      item = xml |> Floki.find("entry") |> List.first()
      assert FeedItem.description(item) =~ "730.000 Mitarbeiter"
    end

    test "can extract from german rss feed" do
      xml = File.read!("cache/feed/spiegel.xml")
      item = xml |> Floki.find("item") |> List.first()
      assert FeedItem.description(item) =~ "Schweres Unglück in der Oberpfalz"
    end

    test "can extract from english atom feed" do
      xml = File.read!("cache/feed/elixir-lang.xml")
      item = xml |> Floki.find("entry") |> List.first()
      assert FeedItem.description(item) =~ "Elixir v1.0 is finally out"
    end

    test "can extract from english rss feed" do
      xml = File.read!("cache/feed/latimes.xml")
      item = xml |> Floki.find("item") |> List.first()
      assert FeedItem.description(item) =~ "high-energy party music"
    end
  end

  describe "FeedItem#website_url/1" do
    test "can extract from xml string of type atom" do
      xml = "<feed><entry><link href='http://example.com' /></entry></feed>"
      assert FeedItem.article_url(xml) == "http://example.com"
    end

    test "can extract from xml string of type rss" do
      xml = "<rss><item><link>http://example.com</link></item></rss>"
      assert FeedItem.article_url(xml) == "http://example.com"
    end

    test "can extract from german atom feed" do
      xml = File.read!("cache/feed/heise.xml")
      item = xml |> Floki.find("entry") |> List.first()
      assert FeedItem.article_url(item) =~ "https://www.heise.de/newsticker"
    end

    test "can extract from german rss feed" do
      xml = File.read!("cache/feed/spiegel.xml")
      item = xml |> Floki.find("item") |> List.first()
      assert FeedItem.article_url(item) =~ "http://www.spiegel.de/panorama"
    end

    test "can extract from english atom feed" do
      xml = File.read!("cache/feed/elixir-lang.xml")
      item = xml |> Floki.find("entry") |> List.first()
      assert FeedItem.article_url(item) =~ "http://elixir-lang.org/blog"
    end

    test "can extract from english rss feed" do
      xml = File.read!("cache/feed/latimes.xml")
      item = xml |> Floki.find("item") |> List.first()
      assert FeedItem.article_url(item) =~ "http://www.latimes.com/la-et-ms"
    end
  end
end