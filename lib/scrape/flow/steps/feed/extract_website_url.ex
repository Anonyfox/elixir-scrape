defmodule Scrape.Flow.Steps.Feed.ExtractWebsiteURL do
  @moduledoc false

  use Scrape.Flow.Step

  def execute(%{dom: dom}, _) when not is_list(dom) and not is_tuple(dom) do
    fail(:dom_invalid)
  end

  def execute(%{dom: dom}, _) do
    case Scrape.IR.Feed.website_url(dom) do
      "" -> assign(website_url: nil)
      url -> assign(website_url: url)
    end
  end

  def execute(_, _) do
    fail(:dom_missing)
  end
end
