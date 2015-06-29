defmodule WebsiteTest do
  use ExUnit.Case
  alias Scrape.Website

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

  defp sample_website(name) do
    File.read! "test/sample_data/#{name}-website.html.eex"
  end
end
