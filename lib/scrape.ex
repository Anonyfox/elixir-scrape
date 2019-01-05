defmodule Scrape do
  alias Scrape.Fetch
  alias Scrape.Feed
  alias Scrape.FeedItem
  alias Scrape.Website
  alias Scrape.Article


  @moduledoc """
  Elixir package to scrape websites. Current features:
    can handle non-utf-8 sources.
    can deal with timezones.
    parse RSS/Atom feeds.
    parse common websites.
    parse advanced content websites ("articles").
  """

  @doc """
  Parse an Atom / RSS Feed.
  Returns a list of items with meta data of each Feed Item, or
  An empty list if something went wrong or Feed is empty
  """

  @spec feed(String.t, Atom) :: [%FeedItem{}] | []

  def feed(url, :minimal) do
    url
    |> Fetch.run
    |> decode_if_needed()
    |> Feed.parse_minimal
  end

  @spec feed(String.t) :: [%FeedItem{}] | []

  def feed(url) do
    url
    |> Fetch.run
    |> decode_if_needed()
    |> Feed.parse(url)
  end
  @doc """
  Parse a website and gets it's various meta data including description, text content, image, tags, favicon and feeds.
  Returns Map with structured meta data.
  """

  @spec website(String.t) :: %Website{}

  def website(url) do
    url
    |> Fetch.run
    |> Website.parse(url)
  end

  @doc """
  Parse an article (website with content) and gets it's various meta data.
  Returns Map with structured meta data (same as website with fulltext field added).
  """

  @spec article(String.t) :: %Article{}

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
        case coded_encoding do
          :utf_8 -> feed_data
          _ -> Codepagex.to_string!(feed_data, coded_encoding)
        end
      [] -> feed_data
    end
  end

end
