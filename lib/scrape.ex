defmodule Scrape do
  alias Scrape.Fetch
  alias Scrape.Website
  alias Scrape.Feed

  def website(url) do
    url
    |> Fetch.run
    |> Website.parse(url)
  end

  def feed(url) do 
    url
    |> Fetch.run
    |> Feed.parse
  end

end
