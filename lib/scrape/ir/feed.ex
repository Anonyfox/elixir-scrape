defmodule Scrape.IR.Feed do
  @moduledoc """
  Information Retrieval implementations to extract data from feeds (RSS or Atom).

  Makes intense use of `Scrape.Tools.Tree` and it's functions to operate on
  nested maps instead of raw XML documents.
  """

  alias Scrape.Tools.Tree
  alias Scrape.Tools.URL

  @doc """
  Extract the (best) title from the feed.

  ## Example
      iex> Feed.title("<feed><title>abc</title></feed>")
      "abc"
  """

  @spec title(String.t() | map()) :: nil | String.t() | map()

  def title(feed) when is_binary(feed) do
    feed |> Tree.from_xml_string() |> title()
  end

  def title(feed) when is_map(feed) do
    Tree.first(feed, ["rss.channel.title", "feed.title"])
  end

  @doc """
  Extract the (best) description from the feed.

  ## Example
      iex> Feed.description("<feed><description>abc</description></feed>")
      "abc"
  """

  @spec description(String.t() | map()) :: nil | String.t() | map()

  def description(feed) when is_binary(feed) do
    feed |> Tree.from_xml_string() |> description()
  end

  def description(feed) when is_map(feed) do
    Tree.first(feed, [
      "rss.channel.description",
      "rss.channel.subtitle",
      "feed.description",
      "feed.subtitle"
    ])
  end

  @doc """
  Extract the website_url from the feed.

  ## Example
      iex> Feed.website_url("<feed><link href='http://example.com' /></feed>")
      "http://example.com"
  """

  @spec website_url(String.t() | map()) :: nil | String.t() | map()

  def website_url(feed) when is_binary(feed) do
    feed |> Tree.from_xml_string() |> website_url()
  end

  def website_url(feed) when is_map(feed) do
    feed
    |> Tree.first(["rss.channel.link", "feed.link.href"])
    |> normalize()
  end

  defp normalize(nil), do: nil
  defp normalize(""), do: nil
  defp normalize(url), do: url |> URL.base()

  @doc """
  Returns the list of all feed items.

  ## Example
      iex> Feed.items("<feed><entry><title>abc</title></entry></feed>")
      [%{"title" => "abc"}]
  """

  @spec items(String.t() | map()) :: nil | [map()]

  def items(feed) when is_binary(feed) do
    feed |> Tree.from_xml_string() |> items()
  end

  def items(feed) when is_map(feed) do
    Tree.find_all(feed, ["feed.entry", "rss.channel.item"])
  end
end
