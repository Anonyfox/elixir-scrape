defmodule Scrape do
  @moduledoc """
  Documentation for Scrape.
  """

  def domain(url) do
    Scrape.Flow.Domain.from_url(url)
  end

  def domain!(url) do
    {:ok, domain} = Scrape.Flow.Domain.from_url(url)
    domain
  end

  def article(url) do
    Scrape.Flow.Article.from_url(url)
  end

  def article!(url) do
    {:ok, article} = Scrape.Flow.Article.from_url(url)
    article
  end
end
