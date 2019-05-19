defmodule Scrape.Flow.Steps.Feed.ExtractDescription do
  @moduledoc false

  use Scrape.Flow.Step

  def execute(%{tree: tree}, _) when not is_map(tree) do
    {:error, :tree_invalid}
  end

  def execute(%{tree: tree}, _) do
    assign(description: Scrape.IR.Feed.description(tree))
  end

  def execute(_, _) do
    fail(:tree_missing)
  end
end
