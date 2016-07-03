defmodule FeedTest do
  use ExUnit.Case, async: true
  alias Scrape.Feed

  test "parser works" do
    xml = sample_feed "elixirlang"
    [ item | _ ] = Feed.parse xml, "http://example.com"
    assert item.title == "Elixir v1.0 released"
    assert item.url == "http://elixir-lang.org/blog/2014/09/18/elixir-v1-0-0-released/"
  end

  test "parser works for german" do
    xml = sample_feed "ntv"
    [ item | _ ] = Feed.parse xml, "http://example.com"
    assert item.title == "Ökonomen warnen: Jobaufschwung verliert an Tempo"
    assert item.tags == [%{accuracy: 0.9, name: "wirtschaft"}]
    assert item.image == "http://bilder1.n-tv.de/img/incoming/crop15393436/2298675318-cImg_4_3-w250/3q7h0527.jpg"
  end

  test "parser works for german with ISO" do
    xml = sample_feed "spiegel"
    [ item | _ ] = Feed.parse xml, "http://example.com"
    assert item.title == "Unglück in Bayern: Zug erfasst Schwertransporter - mehrere Tote"
  end

  test "minimal parser works" do
    xml = sample_feed "ntv"
    list = Feed.parse_minimal xml, "http://example.com"
    assert length(list) == 47
  end

  defp sample_feed(name) do
    File.read! "test/sample_data/#{name}-feed.xml.eex"
  end
end
