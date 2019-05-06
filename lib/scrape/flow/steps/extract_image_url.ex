defmodule Scrape.Flow.Steps.ExtractImageURL do
  @moduledoc false

  def execute(%{dom: dom, url: url}) do
    {:ok, %{image_url: Scrape.IR.DOM.image_url(dom, url)}}
  end
end
