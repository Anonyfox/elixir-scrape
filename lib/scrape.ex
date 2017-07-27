defmodule Scrape do
  alias Scrape.Fetch
  alias Scrape.Feed
  alias Scrape.Website
  alias Scrape.Article

  def feed(url, :minimal) do
    url
    |> Fetch.run
    |> decode_if_needed()
    |> Feed.parse_minimal
  end

  def feed(url) do
    url
    |> Fetch.run
    |> decode_if_needed()
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

  def decode_if_needed(feed_data) do
    case Regex.scan(~r/(?<=encoding=").*?(?=")/, feed_data) do
      [[encoding]] ->
        coded_encoding =
          encoding
            |> String.downcase
            |> String.replace("-", "_")
            |> String.to_atom
        Codepagex.to_string!(feed_data, coded_encoding)
      [] -> feed_data
    end
  end

end
