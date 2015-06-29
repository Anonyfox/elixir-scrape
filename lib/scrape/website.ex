defmodule Scrape.Website do
  alias Scrape.Website

  @moduledoc """
    Every function in this module takes an HTML string, and returns some 
    data extracted from it, mostly strings. Floki is used for parsing
    the raw HTML.

    Usually, we want some general metadata from websites, not a deep text
    analysis or the like. Since this is the foundation of a web crawler
    in the future, the used algorithms should be as fast as possible, even
    when the resulting quality suffers somewhat. 
  """

  defstruct title: "", description: "", url: "", image: "", favicon: "", feeds: [], html: ""

  @spec parse(String.t, String.t) :: Website.Website
  def parse(html, url) do
    %Website{url: url, html: html}
    |> title
    |> description
    |> image
    |> favicon
    |> feeds
    |> link
    |> finalize # post-processing before returning the result
  end

  defp title(site) do 
    value = Floki.find(site.html, "title") 
    |> Floki.text
    %{site | title: value}
  end

  defp description(site) do
    value = Floki.find(site.html, """
      meta[property=og:description],
      meta[name=twitter:description],
      meta[name=description]
    """)
    # |> List.first
    |> Floki.attribute("content")
    |> Util.first_element
    %{site | description: value}
  end

  defp image(site) do
    value = Floki.find(site.html, """
      meta[property=og:image],
      meta[name=twitter:image]
    """)
    # |> List.first
    |> Floki.attribute("content")
    |> List.first
    %{site | image: value}
  end

  defp favicon(site) do
    value = Floki.find(site.html, """
      link[rel=apple-touch-icon],
      link[rel=shortcut icon],
      link[rel=icon]
    """)
    # |> List.first
    |> Floki.attribute("href")
    |> List.first
    %{site | favicon: value}
  end

  defp feeds(site) do
    value = Floki.find(site.html, """
      link[type=application/rss+xml],
      link[type=application/atom+xml],
      link[rel=alternate]
    """)
    |> Floki.attribute("href")
    |> Enum.uniq
    %{site | feeds: value}
  end

  defp link(site) do
    canonical = Floki.find(site.html, "link[rel=canonical]")
    |> Floki.attribute("href")
    |> List.first
    if canonical && URI.parse(canonical).host do
      %{site | url: canonical}
    else 
      site
    end
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