defmodule WebsiteTest do
  use ExUnit.Case, async: true
  alias Scrape.Website

  doctest Scrape.Exquery
  doctest Scrape.Filter
  doctest Scrape.Link

  test "parser works" do
    html = sample_website "venturebeat"
    data = Website.parse html, "http://venturebeat.com"
    assert data.title == "VentureBeat | Tech News That Matters"
    assert data.description == "VentureBeat is the leading source for news & perspective on tech innovation. We give context to help execs, entrepreneurs, & tech enthusiasts make smart decisions."
    assert data.image == nil # DRAGON: needs algorithm update
    assert data.favicon == "http://venturebeat.com/wp-content/themes/vbnews/img/favicon.ico"
    assert data.feeds == ["http://feeds.venturebeat.com/VentureBeat"]
    assert data.url == "http://venturebeat.com"
  end

  test "parser works with german" do
    html = sample_website "ntv"
    data = Website.parse html, "http://example.com"
    assert data.title == "Nachrichten, aktuelle Schlagzeilen und Videos - n-tv.de"
    assert data.description == "Nachrichten seriös, schnell und kompetent. Artikel und Videos aus Politik, Wirtschaft, Börse, Sport und News aus aller Welt."
    assert data.image == nil # DRAGON: needs algorithm update
    assert data.favicon == "http://www.n-tv.de/resources/ts24099052/ver1-0/responsive/img/touch/apple-touch-icon-144x144-precomposed.png"
    assert data.feeds == ["http://www.n-tv.de/rss", "http://mobil.n-tv.de/"]
    assert data.url == "http://www.n-tv.de/"
  end

  test "parser works with german ISO site" do
    html = sample_website "spiegel"
    data = Website.parse html, "http://example.com"
    assert data.title == "Nachrichten - SPIEGEL ONLINE"
    assert data.description == "Deutschlands führende Nachrichtenseite. Alles Wichtige aus Politik, Wirtschaft, Sport, Kultur, Wissenschaft, Technik und mehr."
    assert data.image == nil # DRAGON: needs algorithm update
    assert data.favicon == "http://www.spiegel.de/static/sys/v10/icons/touch-icon-iphone.png"
    assert data.feeds == ["http://www.spiegel.de/schlagzeilen/index.rss",
            "http://www.spiegel.de/index.rss",
            "http://m.spiegel.de/",
            "android-app://de.spiegel.android.app.spon/http/a.spiegel.de/"]
    assert data.url == "http://www.spiegel.de/"
  end

  defp sample_website(name) do
    File.read! "test/sample_data/#{name}-website.html.eex"
  end
end
