defmodule Scrape.IR.FeedItem do
  alias Scrape.Tools.Tree
  alias Scrape.Tools.URL

  @doc """
  Extract the (best) title from the feed item.

  ## Example
      iex> FeedItem.title("<title>abc</title>")
      "abc"
  """

  @spec title(String.t() | map()) :: nil | String.t()

  def title(tree) when is_binary(tree) do
    tree |> Tree.from_xml_string() |> title()
  end

  def title(tree) when is_map(tree) do
    tree
    |> Tree.first(["title"])
    |> normalize_to_string()
  end

  @doc """
  Extract the (best) description from the feed item.

  ## Example
      iex> FeedItem.description("<description>abc</description>")
      "abc"
  """

  @spec description(String.t() | map()) :: nil | String.t()

  def description(tree) when is_binary(tree) do
    tree |> Tree.from_xml_string() |> description()
  end

  def description(tree) when is_map(tree) do
    tree
    |> Tree.first(["description", "summary", "content"])
    |> normalize_to_string()
  end

  @doc """
  Extract the article_url from the feed item.

  ## Example
      iex> FeedItem.article_url("<link href='http://example.com' />")
      "http://example.com"

      iex> FeedItem.article_url("<link href='/url' />", "http://example.com")
      "http://example.com/url"
  """

  @spec article_url(String.t() | map(), nil | String.t()) :: nil | String.t()

  def article_url(tree, url \\ "")

  def article_url(tree, url) when is_binary(tree) do
    tree |> Tree.from_xml_string() |> article_url(url)
  end

  def article_url(tree, url) when is_map(tree) do
    tree
    |> Tree.first(["link.href", "link"])
    |> normalize_to_string()
    |> normalize_url(url)
  end

  @doc """
  Extract the possible tags from the feed item.

  ## Example
      iex> FeedItem.tags("<category>abc</category>")
      ["abc"]

      iex> FeedItem.tags("<feed></feed>")
      []
  """

  @spec tags(String.t() | map()) :: [String.t()]

  def tags(tree) when is_binary(tree) do
    tree |> Tree.from_xml_string() |> tags()
  end

  def tags(tree) when is_map(tree) do
    tree
    |> Tree.find("category")
    |> List.wrap()
    |> Enum.map(&normalize_to_string/1)
    |> Enum.reject(&is_nil/1)
    |> Enum.map(&Scrape.IR.Text.clean/1)
    |> Enum.map(&String.downcase/1)
  end

  @doc """
  Extract the author from the feed item.

  ## Example
      iex> FeedItem.author("<author>abc</author>")
      "abc"
  """

  @spec author(String.t() | map()) :: nil | String.t()

  def author(tree) when is_binary(tree) do
    tree |> Tree.from_xml_string() |> author()
  end

  def author(tree) when is_map(tree) do
    tree
    |> Tree.first(["~creator", "author.name", "author"])
    |> normalize_to_string()
  end

  @doc """
  Extract the image_url from the feed item.

  ## Example
      iex> FeedItem.image_url("<enclosure url='abc' />")
      "abc"
  """

  @spec image_url(String.t() | map(), nil | String.t()) :: nil | String.t()

  def image_url(tree, url \\ "")

  def image_url(tree, url) when is_binary(tree) do
    tree |> Tree.from_xml_string() |> image_url(url)
  end

  def image_url(tree, url) when is_map(tree) do
    tree
    |> Tree.first(["enclosure.url", "media.content"])
    |> normalize_to_string()
    |> inline_image(tree)
    |> normalize_url(url)
  end

  defp inline_image(nil, %{"content" => content}) do
    rx = ~r/\ssrc=["']*(([^'"\s]+)\.(jpe?g)|(png))["'\s]/i

    case Regex.run(rx, content, capture: :all_but_first) do
      [match] when is_binary(match) -> match
      [match | _] when is_binary(match) -> match
      _ -> nil
    end
  end

  defp inline_image(img, _), do: img

  # ensure that a value is either a string or nil, but nothing else
  defp normalize_to_string(value) when is_binary(value), do: value
  defp normalize_to_string(_), do: nil

  # merge an relative url into an absolute url if possible
  defp normalize_url(link, url) when is_binary(url), do: URL.merge(link, url)
  defp normalize_url(link, _), do: link
end
