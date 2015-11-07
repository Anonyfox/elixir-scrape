defmodule Scrape.Website do
  @moduledoc """
    Every function in this module takes an HTML string, and returns some
    data extracted from it, mostly strings. Floki is used for parsing
    the raw HTML.

    Usually, we want some general metadata from websites, not a deep text
    analysis or the like. Since this is the foundation of a web crawler
    in the future, the used algorithms should be as fast as possible, even
    when the resulting quality suffers a little.
  """
  alias Scrape.Website
  alias Scrape.Exquery
  alias Scrape.Link

  defstruct title: "", description: "", url: "", image: "", favicon: "",
    feeds: [], tags: []

  @spec parse(String.t, String.t) :: %Website{}

  def parse(html, url) do
    %Scrape.Website{
      url: url,
      title: find_title(html),
      description: find_description(html),
      image: find_image(html),
      favicon: find_favicon(html),
      feeds: find_feeds(html),
      tags: find_tags(html)
    }
    |> find_canonical(html)
    |> normalize_urls
  end

  @doc """
    Returns the title of a HTML site
  """

  @spec find_title(String.t) :: String.t

  def find_title(html) do
    Exquery.find html, "title", :longest
  end

  @doc """
    Returns the description of a HTML site
  """

  @spec find_description(String.t) :: String.t

  def find_description(html) do
    selector = """
      meta[property='og:description'],
      meta[name='twitter:description'],
      meta[name='description']
    """
    Exquery.attr html, selector, "content", :longest
  end

  @doc """
    Returns the main image url of a HTML site
  """

  @spec find_image(String.t) :: String.t

  def find_image(html) do
    selector = """
      meta[property='og:image'],
      meta[name='twitter:image']
    """
    Exquery.attr html, selector, "content", :first
  end

  @doc """
    Returns the favicon url of a HTML site
  """

  @spec find_favicon(String.t) :: String.t

  def find_favicon(html) do
    selector = """
      link[rel='apple-touch-icon'],
      link[rel='apple-touch-icon-precomposed'],
      link[rel='shortcut icon'],
      link[rel='icon']
    """
    Exquery.attr html, selector, "href", :first
  end

  @doc """
    Returns a list of feed urls for a HTML site
  """

  @spec find_feeds(String.t) :: [String.t]

  def find_feeds(html) do
    selector = """
      link[type='application/rss+xml'],
      link[type='application/atom+xml'],
      link[rel='alternate']
    """
    html |> Exquery.attr(selector, "href", :all)
  end

  @doc """
    Fetch the meta-keywords if exists
  """

  @spec find_tags(String.t) :: [%{name: String.t, accuracy: float}]

  def find_tags(html) do
    html
    |> Exquery.attr("meta[name=keywords]", "content", :all)
    |> Enum.map(fn k -> %{name: k, accuracy: 0.9} end) # *mostly* set by humans
  end

  @doc """
    Look for a canonical url and use it, choose the given URL otherwise
  """

  @spec find_canonical(%Website{}, String.t) :: %Website{}

  def find_canonical(website, html) do
    canonical = Exquery.attr html, "link[rel=canonical]", "href"
    %{website | url: canonical || website.url}
  end

  @doc """
    Iterate over all URLs in the website object and expand them to absolute ones
  """

  @spec normalize_urls(%Website{}) :: %Website{}

  def normalize_urls(website) do
    website
    |> put_lazy(:image, fn(w) -> Link.expand(w.image, w.url) end)
    |> put_lazy(:favicon, fn(w) -> Link.expand(w.favicon, w.url) end)
    |> put_lazy(:feeds, fn(w) ->
      Enum.map(w.feeds, fn(feed) ->
        feed |> Link.expand(w.url)
      end)
      |> Enum.filter(fn url -> String.contains?(url, ["http://", "https://"]) end)
      |> Enum.filter(fn url -> URI.parse(url).path != "/" end)
      |> Enum.filter(fn url -> URI.parse(url).path != "" end)
      |> Enum.filter(fn url -> !String.contains?(url, ["comment", "comments"]) end)
    end)
  end

  defp put_lazy(website, key, fun) do
    if Map.get(website, key) do
      Map.put website, key, fun.(website)
    else
      website
    end
  end

end
