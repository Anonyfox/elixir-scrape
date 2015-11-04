defmodule WebsiteTest do
  use ExUnit.Case, async: true
  alias Scrape.Website

  doctest Scrape.Exquery
  doctest Scrape.Filter
  doctest Scrape.Link

  test "parser works" do
    html = sample_website "venturebeat"
    data = Website.parse html, "http://example.com"
    assert data.title == "VentureBeat | Tech News That Matters"
    assert data.description == "VentureBeat is the leading source for news & perspective on tech innovation. We give context to help execs, entrepreneurs, & tech enthusiasts make smart decisions."
    assert data.image == nil # DRAGON: needs algorithm update
    assert data.favicon == "http://venturebeat.com/wp-content/themes/vbnews/img/favicon.ico"
    assert data.feeds == ["http://feeds.venturebeat.com/VentureBeat"]
    assert data.url == "http://example.com" # DRAGON: search for canonical urls
  end

  test "parser works with german" do
    html = sample_website "ntv"
    data = Website.parse html, "http://example.com"
    assert data.title == "Nachrichten, aktuelle Schlagzeilen und Videos - n-tv.de"
    assert data.description == "Nachrichten seriös, schnell und kompetent. Artikel und Videos aus Politik, Wirtschaft, Börse, Sport und News aus aller Welt."
    assert data.image == nil # DRAGON: needs algorithm update
    assert data.favicon == "http://www.n-tv.de/resources/ts24099052/ver1-0/responsive/img/touch/apple-touch-icon-144x144-precomposed.png"
    assert data.feeds == ["http://www.n-tv.de/rss", "http://mobil.n-tv.de/"]
    assert data.url == "http://www.n-tv.de/" # DRAGON: search for canonical urls
  end

  defp sample_website(name) do
    File.read! "test/sample_data/#{name}-website.html.eex"
  end
end
