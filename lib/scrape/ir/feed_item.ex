defmodule Scrape.IR.FeedItem do
  @typedoc """
  XML tree structure from `Floki.parse/1`
  """
  @type html_tree :: tuple | list

  @doc """
  Extract the (best) title from the feed item.

  ## Example
      iex> Scrape.IR.FeedItem.title("<feed><title>abc</title></feed>")
      "abc"
  """

  @spec title(String.t() | html_tree) :: String.t()

  defdelegate title(dom), to: Scrape.IR.FeedItem.Title, as: :execute

  @doc """
  Extract the (best) description from the feed item.

  ## Example
      iex> Scrape.IR.FeedItem.description("<feed><description>abc</description></feed>")
      "abc"
  """

  @spec description(String.t() | html_tree) :: String.t()

  defdelegate description(dom), to: Scrape.IR.FeedItem.Description, as: :execute

  @doc """
  Extract the article_url from the feed item.

  ## Example
      iex> Scrape.IR.FeedItem.article_url("<feed><link href='http://example.com' /></feed>")
      "http://example.com"
  """

  @spec article_url(String.t() | html_tree) :: String.t()

  defdelegate article_url(dom), to: Scrape.IR.FeedItem.ArticleURL, as: :execute
end
