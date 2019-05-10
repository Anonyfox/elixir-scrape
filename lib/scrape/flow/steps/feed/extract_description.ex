defmodule Scrape.Flow.Steps.Feed.ExtractDescription do
  @moduledoc false

  use Scrape.Flow.Step

  def execute(%{dom: dom}, _) when not is_list(dom) and not is_tuple(dom) do
    {:error, :dom_invalid}
  end

  def execute(%{dom: dom}, _) do
    case Scrape.IR.Feed.description(dom) do
      "" -> assign(description: nil)
      description -> assign(description: description)
    end
  end

  def execute(_, _) do
    fail(:dom_missing)
  end
end
