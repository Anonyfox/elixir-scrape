defmodule Scrape.Flow.Steps.HTML.ExtractTitle do
  @moduledoc false

  use Scrape.Flow.Step

  def execute(%{dom: dom}, _) when not is_list(dom) and not is_tuple(dom) do
    {:error, :dom_invalid}
  end

  def execute(%{dom: dom}, _) do
    assign(title: Scrape.IR.HTML.title(dom))
  end

  def execute(_, _) do
    fail(:dom_missing)
  end
end
