defmodule Scrape.IR.FeedItemTest do
  use ExUnit.Case

  alias Scrape.IR.Feed
  alias Scrape.IR.FeedItem

  doctest FeedItem

  describe "FeedItem#title/1" do
    test "can extract from xml string of type atom" do
      xml = "<title>abc</title>"
      assert FeedItem.title(xml) == "abc"
    end

    test "can extract from xml string of type rss" do
      xml = "<title>abc</title>"
      assert FeedItem.title(xml) == "abc"
    end

    test "can extract from german atom feed" do
      xml = File.read!("cache/feed/heise.xml")
      item = xml |> Feed.items() |> List.first()
      assert FeedItem.title(item) =~ "Fachkräftemangel"
    end

    test "can extract from german rss feed" do
      xml = File.read!("cache/feed/spiegel.xml")
      item = xml |> Feed.items() |> List.first()
      assert FeedItem.title(item) =~ "Schwertransporter"
    end

    test "can extract from english atom feed" do
      xml = File.read!("cache/feed/elixir-lang.xml")
      item = xml |> Feed.items() |> List.first()
      assert FeedItem.title(item) == "Elixir v1.0 released"
    end

    test "can extract from english rss feed" do
      xml = File.read!("cache/feed/latimes.xml")
      item = xml |> Feed.items() |> List.first()
      assert FeedItem.title(item) =~ "Essential tracks"
    end
  end

  describe "FeedItem#description/1" do
    test "can extract from xml string of type atom" do
      xml = "<summary>abc</summary>"
      assert FeedItem.description(xml) == "abc"
    end

    test "can extract from xml string of type rss" do
      xml = "<description>abc</description>"
      assert FeedItem.description(xml) == "abc"
    end

    test "can extract from german atom feed" do
      xml = File.read!("cache/feed/heise.xml")
      item = xml |> Feed.items() |> List.first()
      assert FeedItem.description(item) =~ "730.000 Mitarbeiter"
    end

    test "can extract from german rss feed" do
      xml = File.read!("cache/feed/spiegel.xml")
      item = xml |> Feed.items() |> List.first()
      assert FeedItem.description(item) =~ "Schweres Unglück in der Oberpfalz"
    end

    test "can extract from english atom feed" do
      xml = File.read!("cache/feed/elixir-lang.xml")
      item = xml |> Feed.items() |> List.first()
      assert FeedItem.description(item) =~ "Elixir v1.0 is finally out"
    end

    test "can extract from english rss feed" do
      xml = File.read!("cache/feed/latimes.xml")
      item = xml |> Feed.items() |> List.first()
      assert FeedItem.description(item) =~ "high-energy party music"
    end
  end

  describe "FeedItem#website_url/1" do
    test "can extract from xml string of type atom" do
      xml = "<link href='http://example.com' />"
      assert FeedItem.article_url(xml) == "http://example.com"
    end

    test "can extract from xml string of type rss" do
      xml = "<link>http://example.com</link>"
      assert FeedItem.article_url(xml) == "http://example.com"
    end

    test "can extract from german atom feed" do
      xml = File.read!("cache/feed/heise.xml")
      item = xml |> Feed.items() |> List.first()
      assert FeedItem.article_url(item) =~ "https://www.heise.de/newsticker"
    end

    test "can extract from german rss feed" do
      xml = File.read!("cache/feed/spiegel.xml")
      item = xml |> Feed.items() |> List.first()
      assert FeedItem.article_url(item) =~ "http://www.spiegel.de/panorama"
    end

    test "can extract from english atom feed" do
      xml = File.read!("cache/feed/elixir-lang.xml")
      item = xml |> Feed.items() |> List.first()
      assert FeedItem.article_url(item) =~ "http://elixir-lang.org/blog"
    end

    test "can extract from english rss feed" do
      xml = File.read!("cache/feed/latimes.xml")
      item = xml |> Feed.items() |> List.first()
      assert FeedItem.article_url(item) =~ "http://www.latimes.com/la-et-ms"
    end
  end

  describe "FeedItem#tags/1" do
    test "can extract from xml string of type atom" do
      xml = "<category>abc</category>"
      assert FeedItem.tags(xml) == ["abc"]
    end

    test "can extract from xml string of type rss" do
      xml = "<category>abc</category>"
      assert FeedItem.tags(xml) == ["abc"]
    end

    test "can extract from german atom feed" do
      xml = File.read!("cache/feed/heise.xml")
      item = xml |> Feed.items() |> List.first()
      assert FeedItem.tags(item) == []
    end

    test "can extract from german rss feed" do
      xml = File.read!("cache/feed/spiegel.xml")
      item = xml |> Feed.items() |> List.first()
      assert FeedItem.tags(item) == ["panorama"]
    end

    test "can extract from english atom feed" do
      xml = File.read!("cache/feed/elixir-lang.xml")
      item = xml |> Feed.items() |> List.first()
      assert FeedItem.tags(item) == []
    end

    test "can extract from english rss feed" do
      xml = File.read!("cache/feed/latimes.xml")
      item = xml |> Feed.items() |> List.first()
      assert FeedItem.tags(item) == []
    end
  end

  describe "FeedItem#author/1" do
    test "can extract from xml string of type atom" do
      xml = "<author>abc</author>"
      assert FeedItem.author(xml) == "abc"
    end

    test "can extract from xml string of type rss" do
      xml = "<author>abc</author>"
      assert FeedItem.author(xml) == "abc"
    end

    test "can extract from german atom feed" do
      xml = File.read!("cache/feed/heise.xml")
      item = xml |> Feed.items() |> List.first()
      assert FeedItem.author(item) == nil
    end

    test "can extract from german rss feed" do
      xml = File.read!("cache/feed/spiegel.xml")
      item = xml |> Feed.items() |> List.first()
      assert FeedItem.author(item) == nil
    end

    test "can extract from english atom feed" do
      xml = File.read!("cache/feed/elixir-lang.xml")
      item = xml |> Feed.items() |> List.first()
      assert FeedItem.author(item) == "José Valim"
    end

    test "can extract from english rss feed" do
      xml = File.read!("cache/feed/latimes.xml")
      item = xml |> Feed.items() |> List.first()
      assert FeedItem.author(item) == "Randall Roberts"
    end
  end

  describe "FeedItem#image_url/1" do
    test "can extract from xml string of type atom" do
      xml = "<enclosure url='abc' />"
      assert FeedItem.image_url(xml) == "abc"
    end

    test "can extract from xml string of type rss" do
      xml = "<enclosure url='abc' />"
      assert FeedItem.image_url(xml) == "abc"
    end

    test "can extract from german atom feed" do
      xml = File.read!("cache/feed/heise.xml")
      item = xml |> Feed.items() |> List.first()
      assert FeedItem.image_url(item) =~ "https://www.heise.de/scale/geometry/"
    end

    test "can extract from german rss feed" do
      xml = File.read!("cache/feed/spiegel.xml")
      item = xml |> Feed.items() |> List.first()
      assert FeedItem.image_url(item) == nil
    end

    test "can extract from english atom feed" do
      xml = File.read!("cache/feed/elixir-lang.xml")
      item = xml |> Feed.items() |> List.first()
      assert FeedItem.image_url(item) == nil
    end

    test "can extract from english rss feed" do
      xml = File.read!("cache/feed/latimes.xml")
      item = xml |> Feed.items() |> List.first()
      assert FeedItem.image_url(item) == nil
    end
  end
end
