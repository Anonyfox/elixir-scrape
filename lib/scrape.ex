defmodule Scrape do
  alias Scrape.Fetch
  alias Scrape.Feed
  alias Scrape.Website
  alias Scrape.Article

  def feed(url) do
    url
    |> Fetch.run
    |> Feed.parse(url)
  end

  def website(url) do
    url
    |> Fetch.run
    |> Website.parse(url)
  end

  def article(url) do
    html = Fetch.run url
    website = Website.parse(html, url)
    Article.parse(website, html)
  end

end
