defmodule Scrape.IR.HTML do
  alias Scrape.Tools.DOM

  @doc """
  Extract the best possible title from a HTML document (string or DOM) or nil.

  ## Examples
      iex> HTML.title("")
      nil

      iex> HTML.title("<title>abc</title>")
      "abc"
  """

  @spec title(DOM.dom()) :: nil | String.t()

  @title_queries [
    {"meta[property='og:title']", "content"},
    {"meta[property='twitter:title']", "content"},
    {"h1"},
    {"title"}
  ]

  def title(dom) do
    case DOM.first(dom, @title_queries) do
      nil -> nil
      match -> strip_suffix(match)
    end
  end

  defp strip_suffix(value) do
    rx = ~r/\s[|-].{1}.+$/

    case String.match?(value, rx) do
      true -> value |> String.split(rx) |> List.first()
      false -> value
    end
  end

  @doc """
  Extract the best possible description from a HTML document or nil.

  ## Examples
      iex> HTML.description("")
      nil

      iex> HTML.description("<meta name='description' content='abc' />")
      "abc"
  """

  @spec description(DOM.dom() | String.t()) :: nil | String.t()

  @description_queries [
    {"meta[property='og:description']", "content"},
    {"meta[name='twitter:description']", "content"},
    {"meta[name='description']", "content"}
  ]

  def description(dom) do
    DOM.first(dom, @description_queries)
  end

  @doc """
  Attempts to find the best image_url for the website or nil.

  If a root url is given, will transform relative images to absolute urls.

  ## Examples
      iex> HTML.image_url("")
      nil

      iex> HTML.image_url("<meta property='og:image' content='img.jpg' />")
      "img.jpg"
  """
  @spec image_url(DOM.dom()) :: nil | String.t()
  @spec image_url(DOM.dom(), String.t()) :: nil | String.t()

  @image_url_queries [
    {"meta[property='og:image']", "content"},
    {"meta[name='twitter:image']", "content"}
  ]

  def image_url(dom, url \\ "") do
    case DOM.first(dom, @image_url_queries) do
      nil -> nil
      match -> Scrape.IR.URL.merge(match, url)
    end
  end

  @doc """
  Attempts to find something resembling a favicon url or nil.

  If a root url is given, will transform relative images to absolute urls.

  ## Examples
      iex> HTML.icon_url("")
      nil

      iex> HTML.icon_url("<link rel='shortcut icon' href='img.jpg' />")
      "img.jpg"
  """

  @spec icon_url(DOM.dom()) :: nil | String.t()
  @spec icon_url(DOM.dom(), String.t()) :: nil | String.t()

  @icon_url_queries [
    {"link[rel='apple-touch-icon']", "href"},
    {"link[rel='apple-touch-icon-precomposed']", "href"},
    {"link[rel='shortcut icon']", "href"},
    {"link[rel='icon']", "href"}
  ]

  def icon_url(dom, url \\ "") do
    case DOM.first(dom, @icon_url_queries) do
      nil -> nil
      match -> Scrape.IR.URL.merge(match, url)
    end
  end

  @doc """
  Attempts to fetch all possible feed_urls from the given HTML document.

  ## Examples
      iex> HTML.feed_urls("")
      []

      iex> HTML.feed_urls("<link rel='application/rss+xml' href='feed.rss' />")
      ["feed.rss"]
  """

  @spec feed_urls(DOM.dom()) :: [String.t()]
  @spec feed_urls(DOM.dom(), String.t()) :: [String.t()]

  def feed_urls(dom, url \\ "") do
    list = feed_meta_tag(dom) ++ feed_inline(dom)

    list
    |> Enum.filter(&Scrape.IR.URL.is_http?(&1))
    |> Enum.map(&Scrape.IR.URL.merge(&1, url))
    |> Enum.uniq()
  end

  defp feed_meta_tag(dom) do
    selector = """
      link[type='application/rss+xml'],
      link[type='application/atom+xml'],
      link[rel='alternate']
    """

    DOM.attrs(dom, selector, "href")
  end

  defp feed_inline(dom) do
    rx = ~r{href=['"]([^'"]*(rss|atom|feed|xml)[^'"]*)['"]}
    str = Floki.raw_html(dom)
    matches = Regex.scan(rx, str, capture: :all_but_first)
    Enum.map(matches, &List.first/1)
  end

  @doc """
  Try to extract the relevant text content from a given document.

  Uses the [Readability](https://hex.pm/packages/readability) algorithm, which
  might fail sometimes. Ideally, it returns a single string containing full
  sentences. Remember that this method uses a few heuristics that *somehow*
  work together nicely in many cases, but nothing more.
  """

  @spec content(DOM.dom()) :: nil | String.t()

  def content(dom) do
    try do
      dom
      |> Readability.article()
      |> Floki.filter_out("figure")
      |> Readability.readable_text()
      |> String.replace(~r/\s+/, " ")
      |> String.replace(~r/(\s\S+[a-zäöüß]+)([A-ZÄÖÜ]\S+\s)/u, "\\1. \\2")
    rescue
      _ -> nil
    end
  end

  @doc """
  Convenient fallback function if `content/1` didn't work. Uses `paragraphs/1`
  under the hood.
  """

  @spec sentences(DOM.dom()) :: nil | String.t()

  def sentences(dom) do
    case paragraphs(dom) do
      [] -> nil
      list -> Enum.join(list, ".\n\n")
    end
  end

  @doc """
  Attempt to find the most meaningful content snippets in the HTML document.

  Can be used as a fallback algorithm if `content/1` did return nil but *some*
  text corpus is needed to work with.

  A text paragraph is relevant if it has a minimum amount of characters and
  contains any indicators of a sentence-like structure.
  Very naive approach, but works surprisingly well so far.
  """

  @spec paragraphs(DOM.dom()) :: [String.t()]

  def paragraphs(dom) do
    dom
    |> Floki.find("article, p, div, body")
    |> Enum.map(&Floki.text(&1, deep: false))
    |> Enum.map(&Scrape.IR.Text.normalize_whitespace/1)
    |> Enum.filter(&paragraph_is_relevant?/1)
  end

  defp paragraph_is_relevant?(paragraph) do
    String.length(paragraph) > 30 &&
      String.contains?(paragraph, [". ", "? ", "! ", "\" ", "\", ", ": "])
  end
end
