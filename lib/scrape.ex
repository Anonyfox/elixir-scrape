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
end
