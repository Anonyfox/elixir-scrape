defmodule Scrape.Flow.Steps.HTML.ExtractIconURL do
  @moduledoc false

  use Scrape.Flow.Step

  def execute(%{dom: dom}, _) when not is_list(dom) and not is_tuple(dom) do
    fail(:dom_invalid)
  end

  def execute(%{dom: dom, url: url}, _) do
    assign(icon_url: Scrape.IR.DOM.icon_url(dom, url))
  end

  def execute(%{dom: dom}, _) do
    assign(icon_url: Scrape.IR.DOM.icon_url(dom))
  end

  def execute(_, _) do
    fail(:dom_missing)
  end
end
