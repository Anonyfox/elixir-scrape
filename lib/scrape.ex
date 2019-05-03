defmodule Scrape do
  @moduledoc """
  Documentation for Scrape.
  """

  def domain(url) do
    Scrape.Flow.Domain.execute(url)
  end

  def domain!(url) do
    {:ok, domain} = Scrape.Flow.Domain.execute(url)
    domain
  end

  def article(url) do
    Scrape.Flow.Article.execute(url)
  end

  def article!(url) do
    {:ok, article} = Scrape.Flow.Article.execute(url)
    article
  end
end
