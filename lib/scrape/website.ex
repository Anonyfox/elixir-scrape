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
  alias Scrape.Util.HTML

  defstruct title: "",
    description: "",
    url: "",
    image: "",
    favicon: "",
    feeds: [],
    html: ""

  @spec parse(String.t, String.t) :: %Website{}

  def parse(html, url) do
    %Scrape.Website{url: url, html: html}
    |> title
    |> description
    |> image
    |> favicon
    |> feeds
    |> link
    |> finalize # post-processing before returning the result
  end

  defp title(site) do
    %{site | title: HTML.text(site.html, "title")}
  end

  defp description(site) do
    selector = """
      meta[property='og:description'],
      meta[name='twitter:description'],
      meta[name='description']
    """
    %{site | description: HTML.meta(site.html, selector)}
  end

  defp image(site) do
    selector = """
      meta[property='og:image'],
      meta[name='twitter:image']
    """
    %{site | image: HTML.meta(site.html, selector)}
  end

  defp favicon(site) do
    selector = """
      link[rel='apple-touch-icon'],
      link[rel='apple-touch-icon-precomposed'],
      link[rel='shortcut icon'],
      link[rel='icon']
    """
    %{site | favicon: HTML.meta(site.html, selector, "href")}
  end

  defp feeds(site) do
    selector = """
      link[type='application/rss+xml'],
      link[type='application/atom+xml'],
      link[rel='alternate']
    """
    %{site | feeds: HTML.meta_all(site.html, selector, "href")}
  end

  defp link(site) do
    canonical = HTML.meta(site.html, "link[rel=canonical]", "href")
    %{site | url: canonical || site.url}
  end

  # defp references({site, html}, url) do
  #   value = Floki.find(html, "a")
  #   |> Floki.attribute("href")
  #   |> Enum.filter fn (a) -> (URI.parse(a).host != nil) && (URI.parse(a).host != URI.parse(url).host) end
  #   { %{site | references: value}, html }
  # end

  # POST_PROCESSING:
  # filter out crap and polish the results!

  defp finalize(site) do
    %{site | html: :ok} # the HTML is possibly huge, and not needed any longer now.
    # ToDo: normalize the all URLs/Links to absolute ones
  end

end
