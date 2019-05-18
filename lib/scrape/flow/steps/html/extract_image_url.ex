defmodule Scrape.Flow.Steps.HTML.ExtractImageURL do
  @moduledoc false

  use Scrape.Flow.Step

  def execute(%{dom: dom}, _) when not is_list(dom) and not is_tuple(dom) do
    fail(:dom_invalid)
  end

  def execute(%{dom: dom, url: url}, _) do
    assign(image_url: Scrape.IR.HTML.image_url(dom, url))
  end

  def execute(%{dom: dom}, _) do
    assign(image_url: Scrape.IR.HTML.image_url(dom))
  end

  def execute(_, _) do
    fail(:dom_missing)
  end
end
