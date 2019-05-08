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
end
