defmodule Scrape.IR.Feed do
  @typedoc """
  XML tree structure from `Floki.parse/1`
  """
  @type html_tree :: tuple | list

  @doc """
  Extract the (best) title from the feed.

  ## Example
      iex> Scrape.IR.Feed.title("<feed><title>abc</title></feed>")
      "abc"
  """

  @spec title(String.t() | html_tree) :: String.t()

  defdelegate title(dom), to: Scrape.IR.Feed.Title, as: :execute

  @doc """
  Extract the (best) description from the feed.

  ## Example
      iex> Scrape.IR.Feed.description("<feed><description>abc</description></feed>")
      "abc"
  """

  @spec description(String.t() | html_tree) :: String.t()

  defdelegate description(dom), to: Scrape.IR.Feed.Description, as: :execute
end
