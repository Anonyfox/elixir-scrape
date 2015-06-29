defmodule Scrape do
  alias Scrape.Fetch
  alias Scrape.Website
  alias Scrape.Feed
  
  def website(url \\ "http://www.n24.de/n24/Nachrichten/Politik/d/6792546/bundestags-it-muss-sich-offenbar-ergeben.html") do
    url
    |> Fetch.run
    |> Website.parse(url)
  end

  def feed(url \\ "http://www.n-tv.de/rss") do 
    url
    |> Fetch.run
    |> Feed.parse
  end

end