defmodule Scrape.Flow.Steps.Feed.ExtractWebsiteURL do
  @moduledoc false

  use Scrape.Flow.Step

  def execute(%{tree: tree}, _) when not is_map(tree) do
    fail(:tree_invalid)
  end

  def execute(%{tree: tree}, _) do
    assign(website_url: Scrape.IR.Feed.website_url(tree))
  end

  def execute(_, _) do
    fail(:tree_missing)
  end
end
