defmodule FeedTest do
  use ExUnit.Case, async: true
  alias Scrape.Feed

  test "parser works" do
    xml = sample_feed "elixirlang"
    parsed = Feed.parse(xml, "http://example.com")
    %{ items: [ item | _ ] } = parsed
    assert item.title == "Elixir v1.0 released"
    assert item.url == "http://elixir-lang.org/blog/2014/09/18/elixir-v1-0-0-released/"
  end

  test "parser works for different encodings" do
    "manybooks"
    |> sample_feed()
    |> Scrape.decode_if_needed()
    |> Feed.parse("http://example.com")
  end

  test "parser works for german" do
    xml = sample_feed "ntv"
    %{ items: [ item | _ ] } = Feed.parse xml, "http://example.com"
    assert item.title == "Ökonomen warnen: Jobaufschwung verliert an Tempo"
    assert item.tags == [%{accuracy: 0.9, name: "wirtschaft"}]
    assert item.image == "http://bilder1.n-tv.de/img/incoming/crop15393436/2298675318-cImg_4_3-w250/3q7h0527.jpg"
  end

  test "parser works for german with ISO" do
    xml = sample_feed "spiegel"
    %{ items: [ item | _ ] } = Feed.parse xml, "http://example.com"
    assert item.title == "Unglück in Bayern: Zug erfasst Schwertransporter - mehrere Tote"
  end

  test "parser works for technewsworld" do
    xml = sample_feed "technewsworld"
    %{ items: [ item | _ ] } = Feed.parse xml, "http://www.technewsworld.com/perl/syndication/rssfull.pl"
    assert item.title == "What If We've Got Big Data and Analytics All Wrong?"
  end

  test "minimal parser works" do
    xml = sample_feed "elixirlang"
    items = Feed.parse_minimal xml
    assert length(items) == 20
  end

  test "parser includes article author" do
    [
      {"elixirlang", "José Valim"},
      {"latimes", "Randall Roberts"},
      {"technewsworld", "Rob Enderle"},
    ]
    |> Enum.each(fn {feed, first_author} ->
      xml = sample_feed feed
      %{ items: [ item | _ ] } = Feed.parse xml, ""
      assert item.author == first_author
    end)
  end

  defp sample_feed(name) do
    File.read! "test/sample_data/#{name}-feed.xml.eex"
  end
end
