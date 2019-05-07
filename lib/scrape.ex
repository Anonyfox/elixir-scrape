defmodule Scrape do
  @moduledoc """
  Documentation for Scrape.
  """

  def domain(url, opts \\ []) do
    Scrape.Flow.Domain.from_url(url, opts)
  end

  def domain!(url, opts \\ []) do
    {:ok, domain} = Scrape.Flow.Domain.from_url(url, opts)
    domain
  end

  def article(url, opts \\ []) do
    Scrape.Flow.Article.from_url(url, opts)
  end

  def article!(url, opts \\ []) do
    {:ok, article} = Scrape.Flow.Article.from_url(url, opts)
    article
  end
end
