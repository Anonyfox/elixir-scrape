defmodule Scrape.IR.DOM do
  @typedoc """
  HTML tree structure from `Floki.parse/1`
  """
  @type html_tree :: tuple | list

  @doc """
  Extract the (best) title from the document.

  ## Example
      iex> Scrape.IR.DOM.title("<html><title>interesting!</title></html>")
      "interesting!"
  """

  @spec title(String.t() | html_tree) :: String.t()

  defdelegate title(dom), to: Scrape.IR.DOM.Title, as: :execute

  @doc """
  Extract an existing description from the document.

  ## Example
      iex> Scrape.IR.DOM.description("<meta name='description' content='interesting!' />")
      "interesting!"
  """

  @spec description(String.t() | html_tree) :: String.t()

  defdelegate description(dom), to: Scrape.IR.DOM.Description, as: :execute

  @doc """
  Extract the (best) image_url from the document.

  ## Example
      iex> Scrape.IR.DOM.image_url("<meta property='og:image' content='img.jpg'>")
      "img.jpg"
  """

  @spec image_url(String.t() | html_tree, String.t()) :: String.t()

  defdelegate image_url(dom, url \\ ""), to: Scrape.IR.DOM.ImageURL, as: :execute

  @doc """
  Extract the (best) icon_url from the document.

  ## Example
      iex> Scrape.IR.DOM.icon_url("<link rel='icon' href='img.jpg' />")
      "img.jpg"
  """

  @spec icon_url(String.t() | html_tree, String.t()) :: String.t()

  defdelegate icon_url(dom, url \\ ""), to: Scrape.IR.DOM.IconURL, as: :execute

  @doc """
  Extract a list of all (possible) feed urls from the document.
  """

  @spec feed_urls(String.t() | [any()], String.t() | nil) :: [String.t()]

  defdelegate feed_urls(dom, url \\ ""), to: Scrape.IR.DOM.FeedURLs, as: :execute

  @doc """
  Try to extract the relevant text content from a given document.

  Uses the [Readability](https://hex.pm/packages/readability) algorithm, which
  might fail sometimes. Ideally, it returns a single string containing full
  sentences. Remember that this method uses a few heuristics that *somehow*
  work together nicely in many cases, but nothing more.
  """

  @spec content(String.t() | html_tree) :: String.t() | nil

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
  Try to extract some relevant sentences from a given document.
  """

  @spec paragraphs(String.t() | html_tree) :: [String.t()]

  defdelegate paragraphs(dom), to: Scrape.IR.DOM.Paragraphs, as: :execute
end
