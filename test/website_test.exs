defmodule WebsiteTest do
  use ExUnit.Case, async: true
  alias Scrape.Website

  doctest Scrape.Exquery
  doctest Scrape.Filter
  doctest Scrape.Link
  doctest Scrape.Util.Stopwords
  doctest Scrape.Util.Tags
  doctest Scrape.Util.Text

  test "parser works" do
    html = sample_website "venturebeat"
    data = Website.parse html, "http://venturebeat.com"
    assert data.title == "VentureBeat"
    assert data.description == "VentureBeat is the leading source for news & perspective on tech innovation. We give context to help execs, entrepreneurs, & tech enthusiasts make smart decisions."
    assert data.image == nil # DRAGON: needs algorithm update
    assert data.favicon == "http://venturebeat.com/wp-content/themes/vbnews/img/favicon.ico"
    assert data.feeds == ["http://feeds.venturebeat.com/VentureBeat"]
    assert data.url == "http://venturebeat.com"
    assert data.tags == []
  end

  test "parser works with german" do
    html = sample_website "ntv"
    data = Website.parse html, "http://example.com"
    assert data.title == "Nachrichten, aktuelle Schlagzeilen und Videos"
    assert data.description == "Nachrichten seriös, schnell und kompetent. Artikel und Videos aus Politik, Wirtschaft, Börse, Sport und News aus aller Welt."
    assert data.image == nil # DRAGON: needs algorithm update
    assert data.favicon == "http://www.n-tv.de/resources/ts24099052/ver1-0/responsive/img/touch/apple-touch-icon-144x144-precomposed.png"
    assert data.feeds == ["http://www.n-tv.de/rss"]
    assert data.url == "http://www.n-tv.de/"
    assert data.tags == [%{accuracy: 0.6, name: "schlagzeilen"}]
  end

  test "parser works with german ISO site" do
    html = sample_website "spiegel"
    data = Website.parse html, "http://example.com"
    assert data.title == "Nachrichten"
    assert data.description == "Deutschlands führende Nachrichtenseite. Alles Wichtige aus Politik, Wirtschaft, Sport, Kultur, Wissenschaft, Technik und mehr."
    assert data.image == nil # DRAGON: needs algorithm update
    assert data.favicon == "http://www.spiegel.de/static/sys/v10/icons/touch-icon-iphone.png"
    assert data.feeds == ["http://www.spiegel.de/schlagzeilen/index.rss",
            "http://www.spiegel.de/index.rss"]
    assert data.url == "http://www.spiegel.de/"
    assert data.tags == []
  end

  test "parser finds unusual favicon" do
    html = sample_website "pcgames"
    data = Website.parse html, "http://www.pcgames.de/"
    assert data.favicon == "http://www.pcgames.de/bcommon/gfx/026331d9-f152-40ee-90d9-256990e46f39.png"
  end

  test "parser finds non-obvious rss feed link" do
    html = sample_website "elixirstatus"
    data = Website.parse html, "http://elixirstatus.com/"
    assert data.feeds == ["http://elixirstatus.com/rss"]
  end

  test "useless canonical gets ignored" do
    html = sample_website "elixirgolf"
    data = Website.parse html, "http://elixirgolf.com/"
    assert data.url == "http://elixirgolf.com/"
  end

  test "urls get joined correctly" do
    html = sample_website "hackernews"
    data = Website.parse html, "https://news.ycombinator.com/news"
    assert data.favicon == "https://news.ycombinator.com/favicon.ico"
    assert data.feeds == ["https://news.ycombinator.com/rss"]
  end

  test "hidden RSS links get detected" do
    html = sample_website "washingtonpost"
    data = Website.parse html, "https://www.washingtonpost.com/"
    assert data.feeds == ["http://www.washingtonpost.com/rss"]
  end

  test "twitter accounts on page gets detected" do
    html = sample_website("elixirstatus")
    data = Website.parse(html, "http://elixirstatus.com/")
    assert Enum.member?(data.twitter_accounts, "@elixirstatus")
  end
  defp sample_website(name) do
    File.read! "test/sample_data/#{name}-website.html.eex"
  end
end
