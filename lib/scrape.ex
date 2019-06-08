defmodule Scrape do
  @moduledoc """
  Elixir Toolkit for extracting meaningful structured data out of
  common web resources.

  This process is often called "web-scraping". Actually, the normalization
  and transformation of data into a well-known structured form is also
  known as "data engineering", which in turn is the prerequisite for most
  data-science/machine-learning/... algorithms in the wild.

  Currently Scrape supports 3 types of common web data:

  * Feeds: RSS or Atom XML feeds
  * Domains: "root" pages of a web presence
  * Articles: "content" pages of a web presence
  """

  @doc """
  Given a valid url, return structured data of the content.

  This function is intended for "content" pages.
  """

  @spec article(String.t()) :: {:ok, map()} | {:error, any()}
  @spec article(String.t(), [{atom(), any()}]) :: {:ok, map()} | {:error, any()}

  def article(url, opts \\ []) do
    Scrape.Flow.Article.from_url(url, opts)
  end

  @doc """
  Same as `article/2` but will return the result directly or raise an
  error if the result is not `:ok`
  """

  def article!(url, opts \\ []) do
    {:ok, article} = Scrape.Flow.Article.from_url(url, opts)
    article
  end

  @doc """
  Given a valid url, return structured data of the domain.

  This function is intended for "root" pages of a web presence. The most
  important usecase for Scrape is to detect possible feeds for the domain.
  """

  @spec domain(String.t()) :: {:ok, map()} | {:error, any()}
  @spec domain(String.t(), [{atom(), any()}]) :: {:ok, map()} | {:error, any()}

  def domain(url, opts \\ []) do
    Scrape.Flow.Domain.from_url(url, opts)
  end

  @doc """
  Same as `domain/2` but will return the result directly or raise an
  error if the result is not `:ok`.
  """

  def domain!(url, opts \\ []) do
    {:ok, domain} = Scrape.Flow.Domain.from_url(url, opts)
    domain
  end

  @doc """
  Given a valid url, return structured data of the feed.
  """

  @spec feed(String.t()) :: {:ok, map()} | {:error, any()}
  @spec feed(String.t(), [{atom(), any()}]) :: {:ok, map()} | {:error, any()}

  def feed(url, opts \\ []) do
    Scrape.Flow.Feed.from_url(url, opts)
  end

  @doc """
  Same as `feed/2` but will return the result directly or raise an error
  if the result is not `:ok`.
  """

  def feed!(url, opts \\ []) do
    {:ok, feed} = Scrape.Flow.Feed.from_url(url, opts)
    feed
  end
end
