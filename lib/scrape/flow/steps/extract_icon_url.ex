defmodule Scrape.Flow.Steps.ExtractIconURL do
  @moduledoc false

  def execute(%{dom: dom, url: url}) do
    {:ok, %{icon_url: Scrape.IR.DOM.icon_url(dom, url)}}
  end
end
