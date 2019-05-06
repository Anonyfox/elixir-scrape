defmodule Scrape.Flow.Steps.ExtractDescription do
  @moduledoc false

  def execute(%{dom: dom}) do
    {:ok, %{title: Scrape.IR.DOM.description(dom)}}
  end
end
