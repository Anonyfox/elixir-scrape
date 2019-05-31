defmodule Scrape.Flow.FeedItem do
  @moduledoc false

  alias Scrape.Flow
  alias Scrape.IR.FeedItem, as: Item

  def from_tree(tree, url, opts \\ []) do
    Flow.start(opts)
    |> Flow.assign(tree: tree)
    |> Flow.assign(url: url)
    |> Flow.assign(title: &Item.title(&1[:tree]))
    |> Flow.assign(description: &Item.description(&1[:tree]))
    |> Flow.assign(article_url: &Item.article_url(&1[:tree], &1[:url]))
    |> Flow.assign(tags: &Item.tags(&1[:tree]))
    |> Flow.assign(author: &Item.author(&1[:tree]))
    |> Flow.assign(image_url: &Item.image_url(&1[:tree], &1[:url]))
    |> Flow.finish([:title, :description, :article_url, :tags, :author, :image_url])
  end
end
